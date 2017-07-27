# frozen_string_literal: true

require 'rmega'

module CarrierWave
  module Storage
    class Meganz < Abstract
      def store!(file)
        MeganzFile.new(connection, uploader, uploader.store_path).tap do |meganz_file|
          meganz_file.store(file)
        end
      end

      def retrieve!(file)
        MeganzFile.new(connection, uploader, uploader.store_path(file))
      end

      private

      def connection
        @meganz_client ||= Rmega.login(credentials[:meganz_email], credentials[:meganz_password])
      end

      def credentials
        @credentials ||= {}

        @credentials[:meganz_email] ||= uploader.meganz_email
        @credentials[:meganz_password] ||= uploader.meganz_password

        @credentials
      end
    end
  end
end
