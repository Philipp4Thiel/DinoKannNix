{ config, pkgs, ... }:

{
  networking.hostName = "BiloppDesktop";

  # Desktop specific stuff
  # TODO: add nvidia stuff here I guess

  imports = [ 
  	./common.nix
	../modules/gnome.nix
	# TODO: add desktop hardware config
  ];
}

