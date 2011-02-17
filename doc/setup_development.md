#Setting up sharedearth.net development environment on a local server

##Prequisites

   * You need to have **Bundler** properly installed (`gem install bundler` ; [more info](http://gembundler.com/))
   * If you want to use default **Facebook Connect** application (provided for development purposes) you need to point **senlocal.heroku.com** to 127.0.0.1 in your local hosts file (on Mac/Linux usually: /etc/hosts)
   * If you want to use different domain and your own Facebook app you need to create new Facebook app and modify settings in `config/initializers/omniauth.rb`

##Setup app

   * Clone sharedearth.net repository: `git clone git@github.com:sharedearth-net/sharedearth-net.git`
   * Create database.yml (example database.yml uses sqlite): `cp config/database.yml-sample config/database.yml`
   * Install required gems: `bundle install`
   * Migrate database: `rake db:migrate` (for development)
   * Start server: `rails server`
   * Open [http://senlocal.heroku.com:3000/](http://senlocal.heroku.com:3000/) in your browser

##Using Amazon S3 for storage

By default app will use local file system for storage. If you want to use S3 for storage do this (obviously, you'll need an S3 account):

   * Create s3.yml: `cp config/s3.yml.example config/s3.yml`
   * Edit s3.yml and set access_key_id, secret_access_key and bucket
