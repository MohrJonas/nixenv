# frozen_string_literal: true

require 'cli/ui'

require_relative '../fs_utils'
require_relative '../incus_utils'
require_relative '../incus'

class Down
  def self.run(config)
    FSUtils.ensure_is_nixenv_project(config[:pwd])

    container_name = config[:config][:project][:name]

    IncusUtils.ensure_instance_with_name_exists(container_name)

    CLI::UI::Spinner.spin('Destroying instance') do |_spinner|
      Incus.remove_instance(container_name)
    end
  end
end
