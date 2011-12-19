# -*- encoding : utf-8 -*-

Wordnik.configure do |config|
  config.api_key = configatron.api.key
  config.host = configatron.api.host
  config.base_path = configatron.api.base_path
end
