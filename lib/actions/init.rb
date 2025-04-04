# frozen_string_literal: true

class Init
  def self.run(config)
    default_project_name = File.basename(config[:pwd])
    project_name = CLI::UI.ask('Name of your project?', default: default_project_name)

    default_nixpkgs_channel = 'nixos-24.11'
    nixpkgs_channel = CLI::UI.ask('Used nix channel?', default: default_nixpkgs_channel)

    available_features = %w[x11 wayland gpu pipewire pulseaudio]
    enabled_features = CLI::UI.ask('Features required for your project?', options: available_features, multiple: true)

    CLI::UI::Spinner.spin('Scaffolding project') do |_spinner|
      FS.nixenv_root_folder(config[:pwd]).mkdir
      FS.nixenv_features_folder(config[:pwd]).mkdir
      FS.nixenv_config_file(config[:pwd]).write(Templates.configuration_template(project_name, nixpkgs_channel, enabled_features))
      FS.nixenv_flake_file(config[:pwd]).write(Templates.flake_template(nixpkgs_channel, project_name))
      FS.nixenv_flake_config_file(config[:pwd]).write(Templates.empty_flake)
    end
  end
end
