{ pkgs, ... }:
{
  services = {
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };
}
