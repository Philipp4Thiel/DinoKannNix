{ config, pkgs, ... }:

let
  papi = pkgs.stdenv.mkDerivation {
    pname = "papi";
    version = "7.2.0b2";

    src = pkgs.fetchFromGitHub {
      owner = "icl-utk-edu";
      repo = "papi";
      rev = "papi-7-2-0b2-t";
      sha256 = "sha256-3EBNELJ0fN0PNTqC5hmFCHDk8DsMv9apSR8nztaSyao=";
    };

    nativeBuildInputs = [ ];

    buildInputs = [ pkgs.libpfm ];

    configurePhase = ''
      cd src
      ./configure --prefix=$out
    '';

    buildPhase = ''
      make
    '';

    installPhase = ''
      make install
    '';

    meta.description =
      "Performance API for accessing hardware performance counters";
  };
in {
  home.packages = with pkgs; [
    libgcc
    gcc
    gnumake
    (python312.withPackages
      (ppkgs: [ ppkgs.numpy ppkgs.numba ppkgs.scipy ppkgs.pytest ppkgs.matplotlib ppkgs.jupyter ppkgs.notebook ]))
    papi
  ];
}

