source 'http://rubygems.org'

gem 'rails', '3.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'omniauth', "~> 0.2.6"
gem "aws-s3"
gem "paperclip"
gem "mysql2"

# https://github.com/bclubb/possessive
gem "possessive"

#A full-stack Facebook Graph API wrapper in Ruby. 
gem "fb_graph"

gem "will_paginate", "~> 3.0.pre2"

gem 'rake', '0.9.2'

gem "acts_as_commentable"


# didn't use rails3_acts_as_paranoid because it uses default_scope causing problems with, for example, item_request.item
# https://github.com/goncalossilva/rails3_acts_as_paranoid
# gem "rails3_acts_as_paranoid"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
	gem "shoulda", "~> 2.11"
  gem "rspec-rails", "~> 2.5"
	gem "autotest"
	gem "guard-rspec"
	gem "webrat"
	gem "rcov"
	gem 'factory_girl_rails'
	gem 'ffaker'
	gem 'spork', '~> 0.9.0.rc'
	gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'pickle'
  gem 'heroku_san'
  gem 'nifty-generators'
  gem 'ruby-debug19', :require => 'ruby-debug'
#  gem 'pg'
end
group :production do
  gem 'thin'
end
gem "simplecov", :require => false, :group => :test
gem 'activeadmin'
gem "rails-settings", :git => "git://github.com/100hz/rails-settings.git"
gem 'sass'  #for use in activeadmin
gem "mail"
gem "aws-ses", "~> 0.4.3", :require => 'aws/ses'
gem 'delayed_job' #What you can do today, don't leave for tomorrow

gem "mocha", :group => :test
gem 'whenever', :require => false
gem 'simple_worker'
