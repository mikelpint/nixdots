{
  user,
  lib,
  config,
  pkgs,
  ...
}:
{
  services = {
    jack = {
      jackd = {
        enable = lib.mkDefault false;
      };

      alsa = {
        enable = false;
      };

      loopback = {
        enable = true;
      };
    };

    pipewire = lib.mkIf config.services.pipewire.enable {
      extraConfig = {
        jack = {
          "10-clock-rate" = {
            "jack.properties" = {
              "node.latency" = "128/48000";
              "node.rate" = "1/48000";
            };
          };
        };
      };
    };

    pulseaudio = lib.mkIf (config.services.jack.jackd.enable || config.services.pipewire.jack.enable) {
      package = (config.services.pulseaudio.package or pkgs.pulseaudio).override {
        jackaudioSupport = true;
      };
    };
  };

  boot = lib.mkIf (config.services.jack.jackd.enable || config.services.pipewire.jack.enable) {
    kernelModules = [
      "snd-seq"
      "snd-rawmidi"
    ];
  };

  users = lib.mkIf (config.services.jack.jackd.enable || config.services.pipewire.jack.enable) {
    users = {
      "${user}" = {
        extraGroups = [ "jackaudio" ];
      };
    };
  };

  environment = lib.mkIf (config.services.jack.jackd.enable || config.services.pipewire.jack.enable) {
    systemPackages = with pkgs; [
      libjack2
      jack2
      jack_capture
    ];

    sessionVariables = {
      LD_LIBRARY_PATH = [
        (pkgs.lib.makeLibraryPath (with pkgs; [ pipewire.jack ]))
      ];
    };
  };
}
