{
  description = "Dino kann Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkHost = name: system: hostFile: homeFile:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostFile}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.philipp = import ./home/${homeFile};
            }
          ];
        };
    in {
      nixosConfigurations = {
        thinkpad = mkHost "thinkpad" "x86_64-linux" "thinkpad.nix" "thinkpad.nix";
        desktop  = mkHost "desktop" "x86_64-linux" "desktop.nix" "desktop.nix";
      };
    };
}
