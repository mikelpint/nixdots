{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };

  xdg = {
    portal = {
      wlr = {
        enable = true;
      };
    };
  };

  hardware = {
    graphics = {
      package = lib.mkDefault pkgs.mesa;
      package32 = lib.mkDefault pkgs.pkgsi686Linux.mesa;
    }
    // lib.mkIf (config.programs.hyprland.enable or false) {
      package = inputs.hyprland.inputs.nixpkgs.legacyPackages."${pkgs.system}".mesa;
      package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages."${pkgs.system}".pkgsi686Linux.mesa;
    };
  };

  services = {
    displayManager = {
      sddm = {
        wayland = {
          enable = true;
        };
      };
    };
  };
}
