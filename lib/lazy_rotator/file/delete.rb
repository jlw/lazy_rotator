# frozen_string_literal: true

module LazyRotator
  module File
    # Removes files that have met the current retention limit
    class Delete < Undetermined
      def process
        ::File.delete file_name
      end
    end
  end
end
