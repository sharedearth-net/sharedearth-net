source 'http://rubygems.org'

gem 'rails', '3.2.6'
gem 'mysql2', '>=0.3'
gem 'haml'
gem 'omniauth'
gem "aws-s3"
gem "aws-ses", "~> 0.4.3", :require => 'aws/ses'
gem "paperclip"

gem 'state_machine'
gem "omniauth-facebook"
gem "possessive"
gem "fb_graph"

# ActiveAdmin
gem 'activeadmin', :git => 'git://github.com/gregbell/active_admin.git', :ref => "5c4e75a6d"
gem 'kaminari'
gem "will_paginate", "~> 3.0.3"

gem "rails-settings", :git => "git://github.com/100hz/rails-settings.git"
#gem 'sass'  #for use in activeadmin
#gem "mail"
gem 'delayed_job' #What you can do today, don't leave for tomorrow
gem "daemons" #Support for running delayed_job

gem 'whenever', :require => false
gem 'iron_worker' #Deprecated gem 'simple_worker'
gem 'typhoeus'
gem "acts_as_commentable"

gem 'rinku', :require => 'rails_rinku'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end

test_and_development = Proc.new do
  gem "rspec-rails", "~> 2.5"
  gem "shoulda", "~> 2.11"
  gem "shoulda-matchers"
  gem "autotest"
  gem "guard-rspec"
  gem "webrat"
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'spork', '~> 0.9.0.rc'
  gem 'debugger'
  gem "escape_utils"
  gem 'database_cleaner'
  gem 'pickle'
  gem 'heroku_san'
  #gem 'nifty-generators'
  gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
end

group :development do
  #instance_eval(&test_and_development)
  #gem 'pry'
end

group  :test do
  instance_eval(&test_and_development)
  gem "mocha"
  gem 'cucumber', '~> 1.1.1'
  gem 'cucumber-rails' , '~> 1.1.1'
  gem 'capybara'
  gem "simplecov", :require => false
end

group :production do
  gem 'pg'
  gem 'thin'
  gem "airbrake", :require => false
  gem "heroku"
end
