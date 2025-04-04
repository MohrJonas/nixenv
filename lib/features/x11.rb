# frozen_string_literal: true

require 'json'

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'
require_relative '../utils'

class X11
  def self.apply(instance_name, feature_config)
    use_xauth = feature_config&.fetch(:use_xauth, nil) || !ENV['XAUTHORITY'].nil?
    display = feature_config&.fetch(:display, nil) || ENV['DISPLAY']&.sub(':', '')

    raise 'Unable to determine DISPLAY environment variable. Please define it manually' if display.nil?

    config = {}

    # Handle X11 socket mounting
    Incus.add_bind(instance_name, 'x11_socket', "/tmp/.X11-unix/X#{display}", "/tmp/.X11-unix/X#{display}", true)
    config.deep_merge!({ environment: { variables: { DISPLAY: ":#{display}" } } })

    # Handle Xauthority
    if use_xauth
      xauth = feature_config&.fetch(:xauth, nil) || ENV['XAUTHORITY']
      raise 'Unable to get xauth. Please define it manually' if xauth.nil?

      Incus.add_bind(instance_name, 'xauth', xauth, '/host/xauth', true)
      config.deep_merge!({ environment: { variables: { XAUTHORITY: '/host/xauth' } } })
    end

    # Write nix flake
    FS.nixenv_feature_file(Dir.pwd, 'x11.nix').write(Templates.json_flake(JSON.dump(config).gsub('"', '\"')))
  end

  def self.unapply(instance_name)
    binds = Incus.binds(instance_name)
    Incus.remove_bind(instance_name, 'x11_socket') if binds.include?(:x11_socket)
    Incus.remove_bind(instance_name, 'xauth') if binds.include?(:xauth)

    FS.nixenv_feature_file(Dir.pwd, 'x11.nix').delete
  end
end
