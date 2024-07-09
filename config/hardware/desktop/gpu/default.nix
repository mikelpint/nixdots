{ inputs, pkgs, ... }:

let
  pkgs-unstable =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ./vfio ];

  hardware = {
    opengl = {
      package = pkgs-unstable.mesa.drivers;
      package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;

      enable = true;
      # driSupport = true;
      driSupport32Bit = true;
    };
  };

  environment = { variables = { __GL_VRR_ALLOWED = "0"; }; };
}
