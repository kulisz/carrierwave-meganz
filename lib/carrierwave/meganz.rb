require 'carrierwave/meganz/version'
require 'carrierwave/storage/meganz'
require 'carrierwave'

class CarrierWave::Uploader::Base
  add_config :meganz_email
  add_config :meganz_password

  configure do |config|
    config.storage_engines[:meganz] = 'CarrierWave::Storage::Meganz'
  end
end
