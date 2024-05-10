# README

### Modern rails app with [HotWire](https://hotwired.dev) allowing dialogue between users in real time in several simultaneously open browser tabs (windows). In each tab, the message is received without the need to refresh the page.

### Stack:
* Rails 7.1
* Ruby 3.2.2
* Bun
* Bootstrap
* Devise

### Tests:
* RSpec
* Cucumber

### Instructions for assembling containers and running tests:

1) Run with docker-compose:

`docker-compose up --renew-anon-volumes`

2) Find the id of a container with a rails application

`docker container ls`

| CONTAINER ID |IMAGE           |
|--------------|:--------------:|
| id |  live-chat_web |

3) Prepare dbs with seed for dev and tests:

`docker exec -it <id> bundle exec rails db:prepare`

4) Run rspec tests:

`docker exec -it -e RAILS_ENV=test <id> bundle exec rspec`

5) Run cucumber tests:

`docker exec -it -e RAILS_ENV=test <id> bundle exec cucumber`


See cucumber in action:
* go to http://localhost:7900
* type `secret`
