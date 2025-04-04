# DO NOT EDIT MANUALLY! 
# TO CONFIGURE THE CONTAINER, EDIT THE nixenv.nix FILE INSTEAD!
{
  description = "Nixenv flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/$1";
  };

  outputs = {nixpkgs, self, ...} @ inputs: {
    nixosConfigurations."$2" = nixpkgs.lib.nixosSystem {
      specialArgs={ inherit inputs; };
      modules = let
        feature_path = "${self}/features";
      in (nixpkgs.lib.mapAttrsToList (name: type: "${feature_path}/${name}") (builtins.readDir feature_path)) ++ [./nixenv.nix];
    };
  };
}
