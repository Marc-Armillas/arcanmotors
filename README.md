# README

* Ruby version
3.3.0

* System dependencies
rails version 7.2.1
node version 18.20.4
For installing the img processor run: `brew install vips`


* Configuration
  will need some credentials for AWS S3, ask the admin for it.

* Database
* On Mac
  `brew install postgresql@15`
  `$ brew services start postgresql@15`
  `rake db: create`
  `rake db:migrate`
  `rake db:seed`

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
No queues or services for the moment

* Deployment instructions
  Delpoys automatically from production branch with every merge or commit

* ...
