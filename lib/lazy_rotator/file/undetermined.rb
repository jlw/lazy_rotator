# frozen_string_literal: true

module LazyRotator
  module File
    # The placeholder for a file before determining the correct action as part
    # of the current rotation process
    class Undetermined
      attr_reader :file_name

      def initialize(file_name)
        @file_name = file_name.to_s
      end

      def number
        @number ||= self.class.file_number(file_name)
      end

      def process; end

      # rubocop:disable Metrics/AbcSize
      def ==(other)
        return false if self.class.name != other.class.name
        return false if number != other.number
        return false if file_name != other.file_name
        return true unless respond_to?(:new_number)
        return false if new_number != other.new_number
        true
      end
      # rubocop:enable Metrics/AbcSize

      def <=>(other)
        return number <=> other.number unless number == other.number
        file_name <=> other.file_name
      end

      def self.file_number(file_name)
        file_name.to_s.split('.').last.to_i
      end
    end
  end
end
