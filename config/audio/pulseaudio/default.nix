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
        !((config.services.jack.jackd.enable or false) || (config.services.pipewire.jack.enable or false))
      );
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };

  nixpkgs = {
    config = lib.mkIf false {
      pulseaudio = config.services.pulseaudio.enable or false;
    };
  };
}
