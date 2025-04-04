# frozen_string_literal: true

require 'cli/ui'

require_relative '../fs_utils'
require_relative '../incus_utils'
require_relative '../incus'
require_relative '../features/features'

class Start
  def self.run(config)
    FSUtils.ensure_is_nixenv_project(config[:pwd])
    
    container_name = config[:config][:project][:name]
    
    unless IncusUtils.does_instance_with_name_exist(container_name)
      raise "No container with name #{container_name} exists"
    end

    CLI::UI::Spinner.spin('Starting instance') do |_spinner|
      config[:config][:features].each do |feature_name, feature_config|
        Features.unapply(feature_name, container_name)
        Features.apply(feature_name, container_name, feature_config)
      end
      
      Incus.start_instance(container_name)
    end
  end
end
