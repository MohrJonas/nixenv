# frozen_string_literal: true

require 'json'

class Incus
  def self.instances
    JSON.parse(`incus ls -f json`)
  end

  def self.run_command(instance_name, command)
    `incus exec -T #{instance_name} -- sh -c "source /etc/set-environment && #{command}"`
  end

  def self.run_command_no_environment(instance_name, command)
    `incus exec -T #{instance_name} -- sh -c "#{command}"`
  end

  def self.remove_instance(instance_name)
    `incus delete -f #{instance_name}`
  end

  def self.create_instance(instance_name, image_name)
    `incus create images:#{image_name} #{instance_name}`
  end

  def self.add_bind(container_name, bind_name, host_path, container_path, shift)
    `incus config device add #{container_name} #{bind_name} disk source=#{host_path} path=#{container_path} shift=#{shift}`
  end

  def self.remove_bind(container_name, bind_name)
    `incus config device remove #{container_name} #{bind_name}`
  end

  def self.set_value(container_name, key, value)
    `incus config set #{container_name} #{key} #{value}`
  end

  def self.get_value(container_name, key)
    `incus config get #{container_name} #{key}`
  end

  def self.has_value(container_name, key)
    get_value(container_name, key).strip.empty?
  end

  def self.devices(container_name)
    `incus config device list #{container_name}`.strip.split("\n").map(&:to_sym)
  end

  def self.start_instance(instance_name)
    `incus start #{instance_name}`
  end

  def self.stop_instance(instance_name)
    `incus stop #{instance_name}`
  end

  def self.binds(instance_name)
    `incus config device list #{instance_name}`
    .strip
    .split("\n")
    .filter { |device_name| `incus config device get #{instance_name} #{device_name} type`.strip == 'disk' }
    .map { |device_name| device_name.to_sym }
  end
end
