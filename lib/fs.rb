# frozen_string_literal: true

require 'pathname'

class FS
  def self.nixenv_root_folder(working_directory)
    Pathname.new(working_directory).join('.nixenv')
  end

  def self.nixenv_features_folder(working_directory)
    nixenv_root_folder(working_directory).join('features')
  end

  def self.nixenv_config_file(working_directory)
    Pathname.new(working_directory).join('nixenv.yml')
  end

  def self.nixenv_flake_config_file(working_directory)
    nixenv_root_folder(working_directory).join('nixenv.nix')
  end

  def self.nixenv_flake_file(working_directory)
    nixenv_root_folder(working_directory).join('flake.nix')
  end

  def self.nixenv_feature_file(working_directory, feature_name)
    nixenv_features_folder(working_directory).join(feature_name)
  end
end
