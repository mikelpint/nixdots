{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home = lib.mkIf (osConfig.services.jack.jackd.enable or false) {
    packages = with pkgs; [ qjackctl ];
  };

  xdg = lib.mkIf (osConfig.services.jack.jackd.enable or false) {
    configFile = {
      "pulse/client.conf" = {
        text = ''
          daemon-binary=/var/run/current-system/sw/bin/pulseaudio
        '';
      };
    };
  };

  systemd = lib.mkIf (osConfig.services.jack.jackd.enable or false) {
    user = {
      services = {
        pulseaudio = {
          environment = {
            JACK_PROMISCUOUS_SERVER = "jackaudio";
          };
        };
      };
    };
  };
}
