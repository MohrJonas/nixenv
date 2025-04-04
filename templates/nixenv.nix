{lib, modulesPath, pkgs, ...}: {

  # Add your custom nix configuration here

  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.mesa.drivers];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "yes";
    };
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}