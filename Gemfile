source 'http://rubygems.org'
source 'http://rubygems.cul.columbia.edu/ldpd'

gem 'rails', '~> 3.2.3'
gem 'sqlite3'
gem 'mysql2', '0.3.11'
gem 'nokogiri', '~> 1.5.2'

# For Blacklight
gem 'blacklight', '~> 3.4.0'
gem 'devise'
gem 'jquery-rails'

# For CUL Wind Devise Authentication
gem 'devise_wind'
gem 'devise-encryptable'
gem 'net-ldap'

# For Javascript runtime needed by the asset pipeline
gem 'therubyracer', '0.10.1'

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
  gem 'growl'
  gem 'guard'
  gem 'ruby_gntp'
  gem 'growl_notify'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rspec-rails', '~> 2.9.0'
  gem 'capybara', '1.1.2'
  gem 'capybara-webkit', '0.11.0'

  # To use debugger
  # ruby-debug19 is tricky to install.  Follow instructions from here:
  # https://issues.cul.columbia.edu/browse/HRWA-320
  # gem 'ruby-debug19', :require => 'ruby-debug'
end



#Need to specifically refer to forked net-ssh version because of a capistrano deploy error (from a May 24, 2012 update of net-ssh)
gem 'net-ssh', '~> 2.4.0'



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.12.0'
