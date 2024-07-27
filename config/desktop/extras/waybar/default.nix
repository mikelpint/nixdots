{ osConfig, config, lib, pkgs, ... }: {
  programs = {
    waybar = {
      enable = true;
      package = pkgs.waybar;
    };
  };
}
