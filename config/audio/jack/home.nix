{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home = lib.mkIf osConfig.services.jack.jackd.enable {
    packages = with pkgs; [ qjackctl ];
  };

  xdg = lib.mkIf osConfig.services.jack.jackd.enable {
    configFile = {
      "pulse/client.conf" = {
        text = ''
          daemon-binary=/var/run/current-system/sw/bin/pulseaudio
        '';
      };
    };
  };

  systemd = lib.mkIf osConfig.services.jack.jackd.enable {
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
