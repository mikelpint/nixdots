{ inputs, pkgs, ... }:

let
  pkgs-unstable =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ./amd ./nvidia ];

  hardware = {
    opengl = {
      package = pkgs-unstable.mesa.drivers;
      package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;

      enable = true;
      # driSupport = true;
      driSupport32Bit = true;
    };
  };
}
