# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

%w[User1 User2 User3].each do |username|
  user = User.find_or_initialize_by(username: username)
  user.password = 'Password'
  user.save
end

%w[General Music].each do |name|
  room = Room.find_or_create_by!(name: name)
  content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris laoreet arcu ut massa euismod, sed sodales mi lobortis.'
  2.times { room.messages.create!(content: content, user: User.last) }
end
