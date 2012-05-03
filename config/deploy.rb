set :default_stage, "hrwa_dev"
set :stages, %w(hrwa_dev hrwa_test hrwa_staging hrwa_prod hrwa_local_to_dev hrwa_local_to_test)

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'date'

default_run_options[:pty] = true

set :application, "hrwa"
set :branch do
  default_tag = `git tag`.split("\n").last

  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end

set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :repository,  "git@github.com:cul/hrwa_blacklight.git"
set :use_sudo, false


namespace :deploy do
  desc "Add tag based on current version"
  task :auto_tag, :roles => :app do
    current_version = IO.read("VERSION").strip + Date.today.strftime("-%Y%m%d-%H%M")
    tag = Capistrano::CLI.ui.ask "Tag to add: [#{current_version}] "
    tag = current_version if tag.empty?

    system("git tag -a #{tag} -m 'auto-tagged' && git push origin --tags")
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "mkdir -p #{current_path}/tmp/cookies"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_shared do
    run "ln -nfs #{deploy_to}shared/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}shared/app_config.yml #{release_path}/config/app_config.yml"
    run "mkdir -p #{release_path}/db"
    run "ln -nfs #{deploy_to}shared/#{rails_env}.sqlite3 #{release_path}/db/#{rails_env}.sqlite3"
  end


  desc "Compile assets"
  task :assets do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:clean assets:precompile"
  end

end



after 'deploy:update_code', 'deploy:symlink_shared'
before "deploy:symlink", "deploy:assets"
