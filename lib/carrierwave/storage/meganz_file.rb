# frozen_string_literal: true

module CarrierWave
  module Storage
    class MeganzFile < File
      include CarrierWave::Utilities::Uri
      attr_reader :connection, :path, :uploader

      def initialize(connection, uploader, path)
        @connection = connection
        @uploader = uploader
        @path = path
      end

      def store(file)
        location = uploader.store_path.split('/')[0..-2]

        folder = find_or_initialize_location(location, connection.root)
        folder.upload(file.to_file)
      end

      def url
        object.storage_url
      end

      def public_url
        object.public_url
      end

      def extension
        elements = path.split('.')
        elements.last if elements.size > 1
      end

      def filename
        object.name
      end

      def object
        file_location_dir = @path.split('/')[-2] if @path.split('/').count > 1
        file_name = @path.split('/').last

        folder = if file_location_dir.present?
                   @connection.nodes.find { |node| node.type == :folder && node.name == file_location_dir }
                 else
                   @connection.root
                 end

        folder.files.find { |f| f.name == file_name }
      end

      def find_or_initialize_location(location, parent_folder)
        return parent_folder if location.count.zero?

        child_folder = parent_folder.folders.find { |node| node.name == location.first }
        parent_folder = child_folder ? child_folder : parent_folder.create_folder(location.first)

        find_or_initialize_location(location - [location.first], parent_folder)
      end

      def delete; end
    end
  end
end
