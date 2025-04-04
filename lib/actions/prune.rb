# frozen_string_literal: true

require 'cli/ui'

require_relative '../fs_utils'
require_relative '../incus_utils'
require_relative '../incus'

class Prune
  def self.run(_config)
    containers = Incus.instances

    CLI::UI::Spinner.spin('Pruning instances') do |spinner|
      containers.each do |container|
        spinner.update_title("Pruning #{container['name']}")
        next unless Incus.has_value(container['name'], 'user.nixenv.instance')

        workspace_path = Incus.get_value(container['name'], 'user.nixenv.workspace')

        next if FSUtils.nixenv_project?(workspace_path)
        next if IncusUtils.does_instance_with_name_exist(container['name'])

        CLI::UI::Spinner.spin('Destroying instance') do |_spinner|
          Incus.remove_instance(container_name)
        end
      end
    end
  end
end
