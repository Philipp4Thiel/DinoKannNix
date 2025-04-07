{ config, pkgs, ... }:

{
  imports = [ 
  	./common.nix
	../modules/gnome.nix
	./hardware_configurations/thinkpad.nix
  ];

  networking.hostName = "thinkpad";

  # Laptop specific stuff
}

