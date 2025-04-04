# frozen_string_literal: true

require 'json'
require 'pathname'

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'

class Wayland
  def self.apply(instance_name, feature_config)
    wayland_display = feature_config&.fetch(:display, nil) || ENV['WAYLAND_DISPLAY']

    raise 'Unable to determine WAYLAND_DISPLAY environment variable. Please define it manually' if wayland_display.nil?

    runtime_dir = feature_config&.fetch(:runtime_dir, nil) || ENV['XDG_RUNTIME_DIR']
    raise 'Unable to determine runtime dir. Please define it manually' if runtime_dir.nil?

    wayland_path = Pathname.new(runtime_dir).join(wayland_display)

    unless wayland_path.exist?
      raise 'Unable to determine WAYLAND_DISPLAY environment variable. Please define it manually'
    end

    Incus.add_bind(instance_name, 'wayland_socket', wayland_path,
                   Pathname.new('/host/run').join(wayland_display), true)
    config = { environment: { variables: { WAYLAND_DISPLAY: wayland_display, XDG_RUNTIME_DIR: '/host/run' } } }

    FS.nixenv_feature_file(Dir.pwd, 'wayland.nix').write(Templates.json_flake(JSON.dump(config).gsub('"', '\"')))
  end

  def self.unapply(instance_name)
    Incus.remove_bind(instance_name, 'wayland_socket') if Incus.binds(instance_name).include?(:wayland_socket)
    FS.nixenv_feature_file(Dir.pwd, 'wayland.nix').delete
  end
end
