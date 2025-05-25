{
  description = "Dino kann Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, home-manager, nvf, ... }@inputs:
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
              home-manager.users.philipp = import ./home/philipp.nix {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                inherit nvf;
              };
            }
          ];
        };
    in { nixosConfigurations = { thinkpad = mkHost "thinkpad"; }; };
}
