{ lib, inputs, pkgs, ... }: {
  home = {
    packages = with inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
      [ easyeffects ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = lib.mkForce [ "easyeffects --gapplication-service" ];
        };
      };
    };
  };
}
