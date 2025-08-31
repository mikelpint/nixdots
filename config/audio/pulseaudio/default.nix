{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    pulseaudio = {
      enable = lib.mkDefault (
        !((config.services.jack.jackd.enable or false) || (config.services.pipewire.enable or false))
      );
      support32Bit = true;
      package =
        if
          ((config.services.jack.jackd.enable or false) || (config.services.pipewire.jack.enable or false))
        then
          pkgs.pulseaudioFull
        else
          pkgs.pulseaudio;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };

  nixpkgs = lib.mkIf false {
    config = {
      pulseaudio = config.services.pulseaudio.enable or false;
    };
  };
}
