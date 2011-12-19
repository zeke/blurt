# -*- encoding : utf-8 -*-

# HEY!!
# This file must be loaded before all other initializers -- hence the underscore.

configatron.configure_from_yaml(Rails.root.join('config', 'config.yml'))

# Wipe out environment settings and apply just the settings from the current environment
configatron.environment = nil
configatron.configure_from_hash YAML.load(File.read(Rails.root.join('config', 'config.yml')))['env'][Rails.env]

# When on heroku, grab configuration from ENV.
# Otherwise find it in secrets.yml
if ENV['API_KEY']
  configatron.api.key = ENV['API_KEY']
else
  secrets_file = Rails.root.join('config', 'secrets.yml')
  if File.exists?(secrets_file)
    configatron.configure_from_yaml(secrets_file)
    # environment-specific s3cr3ts, so beta and production can share a common secrets.yml
    configatron.configure_from_hash YAML.load(File.read(secrets_file))['env'][Rails.env]
  end
end
