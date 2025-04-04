# frozen_string_literal: true

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'

class GPU
  def self.apply(instance_name, feature_config)
    gpu = feature_config&.fetch(:gpu, nil) || '/dev/dri/renderD128'

    raise 'Unable to determine gpu. Please define it manually' unless File.exist?(gpu)

    Incus.add_bind(instance_name, 'gpu', gpu, gpu, false)
  end

  def self.unapply(instance_name)
    Incus.remove_bind(instance_name, 'gpu') if Incus.binds(instance_name).include?(:gpu)
  end
end
