{ inputs, pkgs, ... }:

let
  pkgs-unstable =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ./amd ./nvidia ./vfio ];

  hardware = {
    graphics = {
      package = pkgs-unstable.mesa.drivers;
      package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;

      enable = true;
      enable32Bit = true;
    };
  };

  system = {
    userActivationScripts = {
      hyprgpu = { text = builtins.readFile ./hyprgpu; };
    };
  };

  environment = { variables = { __GL_VRR_ALLOWED = "0"; }; };
}
