# encoding: utf-8

require 'rmega'

module CarrierWave
  module Storage
    class Meganz < Abstract
      def store!(file)
        location = uploader.store_path.split('/')[0..-2]

        folder = find_or_initialize_location(location, meganz_client.root)
        # folder.upload(upload_file(file))
        folder.upload(file.to_file)
        # FileUtils.mv(I18n.transliterate(file.file), file.file) unless file.file == I18n.transliterate(file.file)
      end

      def retrieve!(file)
        CarrierWave::Storage::Meganz::File.new(uploader, config, uploader.store_path(file), meganz_client)
      end

      def meganz_client
        @meganz_client ||= Rmega.login(config[:meganz_email], config[:meganz_password])
      end

      private

      def upload_file(file)
        return file.to_file if file.file == I18n.transliterate(file.file)

        FileUtils.mv(file.file, I18n.transliterate(file.file))
        I18n.transliterate(file.file)
      end

      def config
        @config ||= {}

        @config[:meganz_email] ||= uploader.meganz_email
        @config[:meganz_password] ||= uploader.meganz_password

        @config
      end

      def find_or_initialize_location(location, parent_folder)
        return parent_folder if location.count.zero?

        child_folder = parent_folder.folders.find { |node| node.name == location.first }
        parent_folder = child_folder ? child_folder : parent_folder.create_folder(location.first)

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
          object.storage_url
        end

        def public_url
          object.public_url
        end

        def object
          file_location_dir = @path.split('/')[-2] if @path.split('/').count > 1
          file_name = @path.split('/').last

          folder = if file_location_dir.present?
                     @client.nodes.find { |node| node.type == :folder && node.name == file_location_dir }
                   else
                     @client.root
                   end

          folder.files.find { |f| f.name == file_name }
        end

        def delete; end
      end
    end
  end
end
