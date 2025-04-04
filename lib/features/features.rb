# frozen_string_literal: true

require_relative './x11'
require_relative './gpu'
require_relative './pipewire'
require_relative './pulseaudio'
require_relative './wayland'
require_relative './user'

class Features
  def self.apply(feature_name, instance_name, feature_config)
    case feature_name
    when :x11
      X11.apply(instance_name, feature_config)
    when :gpu
      GPU.apply(instance_name, feature_config)
    when :pipewire
      Pipewire.apply(instance_name, feature_config)
    when :pulseaudio
      Pulseaudio.apply(instance_name, feature_config)
    when :wayland
      Wayland.apply(instance_name, feature_config)
    when :user
      User.apply(instance_name, feature_config)
    else
      raise "Unknown feature #{feature_name}"
    end
  end

  def self.unapply(feature_name, instance_name)
    case feature_name
    when :x11
      X11.unapply(instance_name)
    when :gpu
      GPU.unapply(instance_name)
    when :pipewire
      Pipewire.unapply(instance_name)
    when :pulseaudio
      Pulseaudio.unapply(instance_name)
    when :wayland
      Wayland.unapply(instance_name)
    when :user
      User.unapply(instance_name)
    else
      raise "Unknown feature #{feature_name}"
    end
  end
end
