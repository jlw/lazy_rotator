# frozen_string_literal: true

module LazyRotator
  module File
    # Skips processing on a file that does not need to be renamed or deleted
    # during the current rotation (this is an edge case suggesting a previous
    # error or manual deletion of files)
    class Ignore < Undetermined
    end
  end
end
