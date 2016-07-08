source 'http://rubygems.org'
#source 'http://rubygems.cul.columbia.edu/ldpd'

gem 'rails', '~> 3.2.11'
gem 'sqlite3'
gem 'mysql2', '0.3.18'
gem 'nokogiri', '~> 1.5.2'
gem 'rb-fsevent', '~> 0.9.1'
gem 'factory_girl_rails', '3.2.0'

# For Blacklight
gem 'blacklight', '~> 3.4.0'
gem 'devise'
gem 'jquery-rails'

# For CUL Wind Devise Authentication
gem 'devise_wind'
gem 'devise-encryptable'
gem 'net-ldap'

gem 'honeypot-captcha'

# Custom rsolr-ext override
gem 'rsolr-ext', :git => 'git@github.com:cul/rsolr-ext.git', :branch => 'cul-grouping-fixes'

# For Javascript runtime needed by the asset pipeline
gem 'therubyracer', '>= 0.12.2',  platforms: :ruby
gem 'libv8', '>= 3.16.14.13' # Min version for Mac OS 10.11

# Soap gem to interface with hrwa jira project
gem 'jiraSOAP', :git => "git://github.com/cul/jiraSOAP.git"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "compass-rails", "~> 1.0.0"
  gem "compass-susy-plugin", "~> 0.9.0"
  gem 'uglifier', '>= 1.0.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby
end

# Need to lock
gem 'kaminari', '~> 0.13.0'

group :test, :development do
  #gem 'growl'
  gem 'guard'
  gem 'ruby_gntp'
  #gem 'growl_notify'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rspec-rails', '~> 2.9.0'
  gem 'capybara', '1.1.2'
  #gem 'capybara-webkit', '0.11.0'

  # To use debugger
  # ruby-debug19 is tricky to install.  Follow instructions from here:
  # https://issues.cul.columbia.edu/browse/HRWA-320
  # gem 'ruby-debug19', :require => 'ruby-debug'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.12.0'

group :development do
  # Deploy with Capistrano
  gem 'net-ssh', '2.6.5'
  gem 'tins', '1.6.0' # Later versions require Ruby 2.0

  gem 'capistrano', '3.4.0', require: false
  # Rails and Bundler integrations were moved out from Capistrano 3
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  # "idiomatic support for your preferred ruby version manager"
  gem 'capistrano-rvm', '~> 0.1', require: false
  # The `deploy:restart` hook for passenger applications is now in a separate gem
  # Just add it to your Gemfile and require it in your Capfile.
  gem 'capistrano-passenger', '~> 0.1', require: false
end
