# frozen_string_literal: true

require 'carrierwave'
require 'carrierwave/meganz/version'
require 'carrierwave/storage/meganz'
require 'carrierwave/storage/meganz_file'

module CarrierWave
  module Uploader
    class Base
      add_config :meganz_email
      add_config :meganz_password

      configure do |config|
        config.storage_engines[:meganz] = '::CarrierWave::Storage::Meganz'
      end
    end
  end
end
