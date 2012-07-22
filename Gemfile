source 'http://rubygems.org'

ruby '1.9.3'
gem 'bundler', '1.2.0.rc'
gem 'rails', '3.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'omniauth'
gem "aws-s3"
gem "paperclip"

gem 'mysql2', '0.2.18'
gem 'state_machine'
gem "omniauth-facebook"
# https://github.com/bclubb/possessive
gem "possessive"
 
gem "fb_graph"

gem "will_paginate", "~> 3.0.pre2"

gem 'rake', '0.9.2'

gem "simplecov", :require => false, :group => :test
gem 'activeadmin'
gem "rails-settings", :git => "git://github.com/100hz/rails-settings.git"
gem 'sass'  #for use in activeadmin
gem "mail"
gem "aws-ses", "~> 0.4.3", :require => 'aws/ses'
gem 'delayed_job' #What you can do today, don't leave for tomorrow
gem "daemons" #Support for running delayed_job

gem "mocha", :group => :test
gem 'whenever', :require => false
gem 'iron_worker' #Deprecated gem 'simple_worker'
gem 'typhoeus'
gem "acts_as_commentable"

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
  gem 'nifty-generators'
  gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
end

group :development do
  instance_eval(&test_and_development)
  gem 'pry'
end

group  :test do
  instance_eval(&test_and_development)
  gem 'cucumber', '~> 1.1.1'
  gem 'cucumber-rails' , '~> 1.1.1'
  gem 'capybara'
end

group :production do
  gem 'thin'
  gem "airbrake"
  gem "heroku"
end
