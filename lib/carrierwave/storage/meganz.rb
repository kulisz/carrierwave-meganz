require 'rmega'

module CarrierWave
  module Storage
    class Meganz < Abstract
      def store!(file)
        location = uploader.store_path

        folder = find_or_initialize_location(location.split('/')[0..-2], meganz_client.root)
        folder.upload(file.to_file)
      end

      def retrieve!(file)
        CarrierWave::Storage::Meganz::File.new(uploader, config, uploader.store_path(file), meganz_client)
      end

      def meganz_client
        @meganz_client ||= Rmega.login(config[:meganz_email], config[:meganz_password])
      end

      private

      def config
        @config ||= {}

        @config[:meganz_email] ||= uploader.meganz_email
        @config[:meganz_password] ||= uploader.meganz_password

        @config
      end

      def find_or_initialize_location(location, parent_folder)
        return parent_folder if location.count.zero?

        child_folder = parent_folder.folders.find { |node| node.name == location.first }
        parent_folder = parent_folder.create_folder(location.first) unless child_folder

        find_or_initialize_location(location - [location.first], parent_folder)
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def initialize(uploader, config, path, client)
          @uploader = uploader
          @config = config
          @path = path
          @client = client
        end

        def url
          @client.root.files.first.storage_url || @client.root.files.first.public_url
        end

        def download
          @client.root.files.first.download('tmp/')
        end

        def delete; end
      end
    end
  end
end
