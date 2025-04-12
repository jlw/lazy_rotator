# frozen_string_literal: true

module LazyRotator
  # Collects rotated/to-rotate files and decides what to do with each
  class Set
    include Enumerable

    attr_reader :files

    def initialize(file_name, retention_limit)
      # reverse the prepared set so that rotated naming works correctly
      # if I rename '1' to '2' and then '2' to '3', etc. I lose those files
      @files = self.class.prepare_files(file_name, retention_limit).reverse
    end

    def each(&)
      @files.each(&)
    end

    def process
      map(&:process)
    end

    class << self
      def file_regexp(file_name)
        Regexp.new("#{Regexp.quote(file_name)}(\\.\\d+)?$")
      end

      # return a set of collected files with correct processing decisions
      def prepare_files(file_name, retention_limit)
        raw_files = collect_files(file_name.to_s)
        prepared_files = [File::Touch.new(file_name)]
        delete_after = retention_limit - 1
        next_number = 1
        raw_files.each do |file|
          prepared_files << prepare_file(file, delete_after, next_number)
          next_number += 1
        end
        prepared_files
      end

      private

      # find all matching files that should be processed as part of the rotation
      def collect_files(file_name)
        regexp     = file_regexp(file_name)
        naive_list = Dir.glob("#{file_name}*")
        file_list  = naive_list.select { |f| regexp.match(f) }
        file_list.map { |f| File::Undetermined.new(f) }.sort
      end

      def prepare_file(file, delete_after, next_number)
        corrected_number = next_number - 1
        if corrected_number > delete_after
          File::Delete.new(file.file_name)
        elsif file.number == next_number
          File::Ignore.new(file.file_name)
        else
          File::Rename.new(file.file_name, next_number)
        end
      end
    end
  end
end
