# frozen_string_literal: true

require_relative './incus'

class IncusUtils
  def self.does_instance_with_name_exist(instance_name)
    Incus.instances.any? { |instance| instance['name'] == instance_name }
  end

  def self.ensure_instance_with_name_exists(instance_name)
    raise "Container with name #{instance_name} does not exist" unless does_instance_with_name_exist(instance_name)
  end

  def self.rebuild(instance_name)
    Incus.run_command_no_environment(instance_name, "nixos-rebuild switch --flake /etc/nixos##{instance_name}")
  end
end
