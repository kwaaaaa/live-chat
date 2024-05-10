require 'cucumber/rails'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

if ENV['SELENIUM_HOST'].present?
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app,
                                   browser: :remote,
                                   url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}",
                                   options: chrome_options
    )
  end

  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = "3009"
  Capybara.app_host = "http://web:3009"
  # Capybara.app_host = "http://#{Socket.gethostname}:#{Capybara.server_port}"

else
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
end

Capybara.javascript_driver = :chrome

Cucumber::Rails::Database.javascript_strategy = :truncation
