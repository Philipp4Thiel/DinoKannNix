{
  description = "Dino kann Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${name}.nix
            {
              imports = [ home-manager.nixosModules.home-manager ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.philipp = import ./home/philipp.nix;
            }
          ];
        };
    in { nixosConfigurations = { thinkpad = mkHost "thinkpad"; }; };
}
