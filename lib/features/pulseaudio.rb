# frozen_string_literal: true

require 'pathname'

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'

class Pulseaudio
  def self.apply(instance_name, feature_config)
    runtime_dir = feature_config&.fetch(:runtime_dir, nil) || ENV['XDG_RUNTIME_DIR']
    raise 'Unable to determine runtime dir. Please define it manually' if runtime_dir.nil?

    pulseaudio_path = Pathname.new(runtime_dir).join('pulse')

    raise 'Unable to determine pulseaudio socket. Please define it manually' unless pulseaudio_path.exist?

    Incus.add_bind(instance_name, 'pulseaudio_socket', pulseaudio_path, Pathname.new('/host/run').join('pulse'), true)
  end

  def self.unapply(instance_name)
    Incus.remove_bind(instance_name, 'pulseaudio_socket') if Incus.binds(instance_name).include?(:pulseaudio_socket)
  end
end
