# frozen_string_literal: true

require_relative './fs'

class FSUtils
  def self.nixenv_project?(directory)
    FS.nixenv_config_file(directory).file?
  end

  def self.ensure_is_nixenv_project(directory)
    raise "Current working directory #{directory} is not a nixenv project" unless FSUtils.nixenv_project?(directory)
  end
end
