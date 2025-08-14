{ pkgs, osConfig, ... }:
{
  home = {
    packages = with pkgs; [ pavucontrol ];
  };

  programs = {
    mangohud = {
      settingsPerApplication = {
        pavucontrol = {
          no_display = true;
        };
      };
    };
  };

  nixpkgs = {
    config = {
      pulseaudio = osConfig.nixpkgs.config.pulseaudio or false;
    };
  };
}
