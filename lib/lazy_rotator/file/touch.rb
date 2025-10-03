# frozen_string_literal: true

require 'fileutils'

module LazyRotator
  module File
    # Ensure the initial file is in place
    class Touch < Undetermined
      def process
        return unless number.zero?

        FileUtils.touch file_name
      end
    end
  end
end
