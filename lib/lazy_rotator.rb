# frozen_string_literal: true

require 'lazy_rotator/file'
require 'lazy_rotator/set'
require 'lazy_rotator/version'

# Rotate a set of files
module LazyRotator
  def self.rotate(file_name, retention_limit = 5)
    return unless ::File.exist? file_name

    Set.new(file_name, retention_limit).process
  end
end
