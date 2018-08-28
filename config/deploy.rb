# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :department, 'ldpd'
set :instance, fetch(:department)
set :application, 'hrwa'
set :repo_url, "git@example.com:me/my_repo.git"

set :deploy_name, "#{fetch(:application)}_#{fetch(:stage)}"
# used to run rake db:migrate, etc
# Default value for :rails_env is fetch(:stage)
set :rails_env, fetch(:deploy_name)
# use the rvm wrapper
set :rvm_ruby_version, fetch(:deploy_name)

set :repo_url,  "git@github.com:cul/#{fetch(:repo_name)}.git"

set :remote_user, "#{fetch(:instance)}serv"
# Default deploy_to directory is /var/www/:application
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to,   "/opt/passenger/#{fetch(:instance)}/#{fetch(:deploy_name)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug
set :log_level, :info

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# Default value for keep_releases is 5
set :keep_releases, 3

set :passenger_restart_with_touch, true

set :linked_files, fetch(:linked_files, []).push(
  "config/database.yml",
)
