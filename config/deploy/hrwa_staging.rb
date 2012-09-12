set :rails_env, "hrwa_staging"
set :application, "hrwa_staging"
set :domain,      "berlioz.cul.columbia.edu"
set :deploy_to,   "/opt/passenger/#{application}/"
set :user, "deployer"
set :scm_passphrase, "Current user can full owner domains."

role :app, domain
role :web, domain
role :db,  domain, :primary => true
