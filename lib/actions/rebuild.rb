# frozen_string_literal: true

require 'cli/ui'

require_relative '../fs_utils'
require_relative '../incus_utils'

class Rebuild
  def self.run(config)
    FSUtils.ensure_is_nixenv_project(config[:pwd])
    container_name = config[:config][:project][:name]

    unless IncusUtils.does_instance_with_name_exist(container_name)
      raise "No container with name #{container_name} exists"
    end

    CLI::UI::Spinner.spin('Rebuilding instance') do |_spinner|
      IncusUtils.rebuild(container_name)
    end
  end
end
