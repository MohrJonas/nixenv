# frozen_string_literal: true

require 'cli/ui'

require_relative '../fs_utils'
require_relative '../incus_utils'
require_relative '../incus'
require_relative '../features/features'

class Up
  def self.run(config)
    FSUtils.ensure_is_nixenv_project(config[:pwd])

    container_name = config[:config][:project][:name]

    if IncusUtils.does_instance_with_name_exist(container_name)
      raise "Container with name #{container_name} already exists"
    end

    CLI::UI::Spinner.spin('Creating instance') do |_spinner|
      Incus.create_instance(container_name, 'nixos/unstable')

      Incus.add_bind(container_name, 'workspace', config[:pwd], '/workspace', true)
      Incus.add_bind(container_name, 'configuration', FS.nixenv_root_folder(config[:pwd]), '/etc/nixos', true)

      Incus.set_value(container_name, 'user.nixenv.instance', '1')
      Incus.set_value(container_name, 'user.nixenv.workspace', config[:pwd])
      Incus.set_value(container_name, 'security.nesting', '1')

      config[:config][:features].each do |feature_name, feature_config|
        Features.apply(feature_name, container_name, feature_config)
      end

      Incus.start_instance(container_name)
      IncusUtils.rebuild(container_name)
    end
  end
end
