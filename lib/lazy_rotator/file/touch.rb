# frozen_string_literal: true

module LazyRotator
  module File
    # Ensure the initial file is in place
    class Touch < Undetermined
      def process
        return unless number.zero?
        ::FileUtils.touch file_name
      end
    end
  end
end
