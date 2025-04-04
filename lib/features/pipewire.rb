# frozen_string_literal: true

require 'pathname'

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'

class Pipewire
  def self.apply(instance_name, feature_config)
    pipewire_name = feature_config&.fetch(:socket, nil) || 'pipewire-0'

    runtime_dir = feature_config&.fetch(:runtime_dir, nil) || ENV['XDG_RUNTIME_DIR']
    raise 'Unable to determine runtime dir. Please define it manually' if runtime_dir.nil?

    pipewire_path = Pathname.new(runtime_dir).join(pipewire_name)

    raise 'Unable to determine pipewire socket. Please define it manually' unless pipewire_path.exist?

    Incus.add_bind(instance_name, 'pipewire_socket', pipewire_path, Pathname.new('/host/run').join(pipewire_name), true)
  end

  def self.unapply(instance_name)
    Incus.remove_bind(instance_name, 'pipewire_socket') if Incus.binds(instance_name).include?(:pipewire_socket)
  end
end
