Before do
  FactoryBot.create(:room, name: 'Все пользователи')
  @session_manager = UserSessionManager.new
end

class UserSessionManager
  attr_accessor :user, :cookies, :manage, :wait

  def initialize
    @manage = Capybara.current_session.driver.browser.manage
    errors = [Selenium::WebDriver::Error::NoSuchElementError,
              Selenium::WebDriver::Error::NoSuchCookieError]
    @wait = Selenium::WebDriver::Wait.new(timeout: 3, interval: 0.4, ignore: errors)
    @cookies = {}
  end

  def create(username)
    Capybara.switch_to_window Capybara.open_new_window(:tab)
    FactoryBot.create(:user, username: username, password: 'Password')

    yield

    @cookies["#{username}"] = @wait.until { @manage.cookie_named('_live_chat_session')[:value] }
    @manage.delete_all_cookies
  end

  def switch(username)
    @manage.delete_all_cookies
    @manage.add_cookie({ name: '_live_chat_session', value: @cookies[username] })
    @wait.until { @manage.cookie_named('_live_chat_session')[:value] }
    index = @cookies.keys.index(username) + 1
    Capybara.switch_to_window Capybara.page.windows[index]
  end
end

Дано('{string} входит в приложение в одном окне браузера') do |username|
  @session_manager.create(username) do
    visit('/users/sign_in')
    fill_in('Username', with: username)
    fill_in('Password', with: 'Password')
    click_on 'Log in'
  end
end

Если('Пользователь 1 пишет Пользователю 2 «Сообщение 1»') do
  @session_manager.switch('Пользователь 1')
  click_on 'пользователь 2'
  fill_in('chat-text', with: 'Сообщение 1')
  click_on 'Create Message'
  sleep 2
end

И('В группу «все пользователи» «Сообщение 2»') do
  click_on 'Все пользователи'
  sleep 2
  fill_in('chat-text', with: 'Сообщение 2')
  click_on 'Create Message'
  sleep 2
end

То('Пользователь 2 получает оба сообщени') do
  @session_manager.switch('Пользователь 2')
  click_on 'пользователь 1'
  sleep 2
  expect(page).to have_text('Сообщение 1')
  click_on 'Все пользователи'
  sleep 2
  expect(page).to have_text('Сообщение 2')
end

И('Пользователь 3 получает Сообщение 2') do
  @session_manager.switch('Пользователь 3')
  click_on 'Все пользователи'
  expect(page).to have_text('Сообщение 2')
end
