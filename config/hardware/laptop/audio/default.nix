# https://github.com/fufexan/nix-gaming/blob/master/modules/pipewireLowLatency.nix

{ lib, pkgs, ... }:

let
  quantum = 32;
  rate = 96000;
  quantumRate = rate / quantum;
in
{
  services = {
    pipewire = {
      extraConfig = {
        pipewire = {
          "99-lowlatency" = {
            context = {
              properties = {
                default = {
                  clock = {
                    min-quantum = quantum;
                  };
                };
              };

              modules = [
                {
                  name = "libpipewire-module-rtkit";
                  flags = [
                    "if-exists"
                    "nofail"
                  ];
                  args = {
                    nice = {
                      level = -15;
                    };

                    rt = {
                      prio = 88;
                      time = {
                        soft = 200000;
                        hard = 200000;
                      };
                    };
                  };
                }

                {
                  name = "libpipewire-module-protocol-pulse";
                  args = {
                    server = {
                      address = [ "unix:native" ];
                      pulse = {
                        min = {
                          req = quantumRate;
                          quantum = quantumRate;
                          frag = quantumRate;
                        };
                      };
                    };
                  };
                }

                {
                  name = "libpipewire-module-allow-passthrough";
                  flags = [
                    "if-exists"
                    "nofail"
                  ];
                }

                {
                  name = "libpipewire-module-allow-24bit";
                  flags = [
                    "if-exists"
                    "nofail"
                  ];
                }

                {
                  name = "libpipewire-module-allow-32bit";
                  flags = [
                    "if-exists"
                    "nofail"
                  ];
                }
              ];

              stream = {
                properties = {
                  node = {
                    latency = quantumRate;
                  };

                  resample = {
                    quality = 1;
                  };
                };
              };
            };
          };
        };
      };

      wireplumber = {
        configPackages =
          let
            matches =
              lib.generators.toLua
                {
                  multiline = false;
                  indent = false;
                }
                [
                  [
                    [
                      "node.name"
                      "matches"
                      "alsa_output.*"
                    ]
                  ]
                ];

            apply_properties = lib.generators.toLua { } {
              "audio.format" = "S32LE";
              "audio.rate" = rate * 2;
              "api.alsa.period-size" = 2;
            };
          in
          [
            (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
              alsa_monitor.rules = {
                {
                  matches = ${matches};
                  apply_properties = ${apply_properties};
                }
              }
            '')
          ];
      };
    };
  };

  boot = {
    extraModprobeConfig = ''
      options snd-hda-intel single_cmd=1
      options snd-hda-intel probe_mask=1
      options snd-hda-intel model=basic
    '';
  };
}
