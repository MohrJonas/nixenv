# frozen_string_literal: true

require 'yaml'

class Templates
  def self.flake_template(nixpkgs_channel, hostname)
    puts File.expand_path(__dir__)
    template_text = File.read("#{File.expand_path(__dir__)}/../templates/flake.nix")
    template_text.sub!('$1', nixpkgs_channel)
    template_text.sub!('$2', hostname)
    template_text
  end

  def self.configuration_template(project_name, nixpkgs_channel, enabled_features)
    #template_text = File.read("#{File.expand_path(__dir__)}/../templates/nixenv.yml")
    #template_text.sub!('$1', project_name)
    #template_text.sub!('$2', nixpkgs_channel)
    #template_text
    
    config = {"project" => { "name" => project_name, "nixpkgs_channel" => nixpkgs_channel }, "features" => {}}
    enabled_features.each do |feature_name|
      config["features"][feature_name] = nil
    end
    YAML.dump(config)
  end

  def self.empty_flake
    File.read("#{File.expand_path(__dir__)}/../templates/nixenv.nix")
  end

  def self.json_flake(json_contents)
    template_text = File.read("#{File.expand_path(__dir__)}/../templates/json.nix")
    template_text.sub!('$1', json_contents)
    template_text
  end
end
