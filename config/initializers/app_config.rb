begin
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
rescue
  APP_CONFIG = {}
end
