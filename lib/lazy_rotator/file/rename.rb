# frozen_string_literal: true

module LazyRotator
  module File
    # Moves a file along in the rotation (assuming it should still be kept)
    class Rename < Undetermined
      attr_reader :new_number

      def initialize(file_name, new_number)
        @new_number = new_number
        super(file_name)
      end

      def file_name_without_number
        @file_name_without_number ||= begin
          m = Regexp.new("^(.+)\\.#{number}$").match(::File.basename(file_name))
          m ? ::File.join(::File.dirname(file_name), m[1]) : file_name
        end
      end

      def new_file_name
        "#{file_name_without_number}.#{new_number}"
      end

      def process
        ::File.rename(file_name, new_file_name)
      end
    end
  end
end
