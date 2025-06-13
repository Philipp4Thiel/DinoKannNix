{
  description = "Dino kann Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    
    openconnect-sso-src = {
      url = "github:arthur-d42/openconnect-sso/master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf, poetry2nix, openconnect-sso-src, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          poetry2nix = poetry2nix.lib.mkPoetry2Nix { pkgs = prev; };
          
          # Import the overlay from the source
          openconnect-sso-overlay = import "${openconnect-sso-src}/overlay.nix";
          
          # Apply the overlay to get the package
          openconnect-sso = ((prev.extend (self: super: {
            inherit (final) poetry2nix;
          })).extend final.openconnect-sso-overlay).openconnect-sso;
        })
      ];
      
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Apply overlays to the system
            { nixpkgs.overlays = overlays; }
            ./hosts/${name}.nix
            {
              imports = [ home-manager.nixosModules.home-manager ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs nvf; };
              home-manager.users.philipp = import ./home/philipp.nix;
            }
          ];
        };
    in { nixosConfigurations = { thinkpad = mkHost "thinkpad"; }; };
}