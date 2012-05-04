source 'http://rubygems.org'

gem 'rails', '3.2.3'

gem 'rsolr', :git => 'git://github.com/mwmitchell/rsolr.git', :tag => 'v1.0.7'
gem 'rsolr-ext', :git => 'git@github.com:cul/rsolr-ext.git'
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '3.0.1'
gem 'blacklight', '3.4.0'
gem 'capistrano', '2.12.0'
gem 'capistrano-ext', '1.2.1'
gem 'devise', '2.0.4'
gem 'jquery-rails', '2.0.2'
gem 'json', '1.6.6'
gem 'mysql2', '0.3.11'
gem 'nokogiri', '1.5.2'
gem 'sass', '3.1.16'
gem 'sass-rails', '3.2.5'
gem 'spreadsheet', '0.6.8'
gem 'sqlite3', '1.3.6'
gem 'therubyracer', '0.10.1'
# Use unicorn as the web server
# gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', '0.10.1'
  gem 'coffee-rails', '3.2.2'
  gem 'sass-rails', '3.2.5'
  gem 'uglifier', '1.2.4'
  gem 'compass-rails', '~> 1.0.0'
  gem 'compass-susy-plugin', '~> 0.9.0'
end

group :test, :development do
  # Pretty printed test output
  gem 'capybara', '1.1.2'
  gem 'capybara-webkit', '0.11.0'
  gem 'database_cleaner', '0.7.2'
  gem 'factory_girl_rails', '3.2.0'
  gem 'growl', '1.0.3'
  gem 'guard', '1.0.1'
  gem 'guard-rails', '0.1.0'
  gem 'guard-rspec', '0.7.0'
  gem 'guard-spork', '0.7.1'
  gem 'launchy', '2.1.0'
  gem 'rb-fsevent', '0.9.1'
  gem 'rb-readline', '0.4.2'
  gem 'rspec-rails', '2.9.0'
  gem 'ruby_gntp', '0.3.4'
  gem 'ruby-prof', '0.10.8'
  gem 'spork', '0.9.0'
  
  # To use debugger
  # ruby-debug19 is tricky to install.  Follow instructions from here:
  # https://issues.cul.columbia.edu/browse/HRWA-320
  gem 'linecache19', '0.5.13', :path => "~/.rvm/gems/ruby-1.9.3-p0/gems/linecache19-0.5.13/"
  gem 'ruby-debug-base19', '0.11.26', :path => "~/.rvm/gems/ruby-1.9.3-p0/gems/ruby-debug-base19-0.11.26/"
  # These changes below might have been made by Nada and accidentally committed by me.
  # Temporarily disabling these to try to resolve
  # https://issues.cul.columbia.edu/browse/HRWA-407
  # gem 'linecache19', '0.5.13'
  # gem 'ruby-debug-base19', '0.11.26'
  gem 'ruby-debug19', :require => 'ruby-debug'
end
