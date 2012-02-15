# Developers can customize their Guard setup using config/local_guardfile_customizations.yml
# config/local_guardfile_customizations.yml should be in .gitignore

# Default notification options
gntp_opts = {
             :host   => 'localhost',
             :sticky => false,
            }
            
# Default rails options
rails_opts = {
              :port     => 3020,
             }

# Local customizations
config_file = File.dirname(__FILE__) + '/config/local_guardfile_customizations.yml'
if File.exists?(config_file)
  config = YAML.load_file(config_file)
  
  # Set notification options
  if config["notification_gntp"]
    gntp_opts[:host]     = config["notification_gntp"]["host"]     if config["notification_gntp"]["host"]
    gntp_opts[:sticky]   = config["notification_gntp"]["sticky"]   if config["notification_gntp"]["sticky"]
    gntp_opts[:password] = config["notification_gntp"]["password"] if config["notification_gntp"]["password"]
  end
  
  # Set rails options
  if config["rails"]
    rails_opts[:debugger] = config["rails"]["debugger"] if config["rails"]["debugger"]
    rails_opts[:port]     = config["rails"]["port"]     if config["rails"]["port"]
  end
end

notification :gntp, gntp_opts

guard 'rails', rails_opts do
  watch('Gemfile.lock')
  watch(%r{^config/.*})
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard 'rspec', :version => 2, :cli => "--color --drb --format progress" , :all_on_start => true, :all_after_pass => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^app/views/layouts/.*\.(erb|haml)$})       { |m| "spec/requests" }
end


guard 'cucumber', :cli => '--no-profile --color --format pretty --strict' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

