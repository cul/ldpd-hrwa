set :rails_env, "hrwa_dev"
set :application, "hrwa_dev"
set :domain,      "bronte.cul.columbia.edu"
set :deploy_to,   "/opt/passenger/#{application}/"
set :user, "deployer"
set :scm_passphrase, "Current user can full owner domains."

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# Overriding deploy.rb
set :deploy_via, :copy
# Copnsider using this
# set :copy_cache, true
set :repository,  "."
