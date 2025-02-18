{ pkgs, ... }: {
  services = {
    pipewire = {
      enable = true;

      extraConfig = {
        pipewire = {
          "10-easyeffects-sink" = {
            "context.objects" = [{
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "easyeffects_sink";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" "FC" "LFE" "RL" "RR" ];
                "monitor.channel-volumes" = true;
                "monitor.passthrough" = true;
                "adapter.auto-port-config" = {
                  mode = "dsp";
                  monitor = true;
                  position = "preserve";
                };
              };
            }];
          };
        };
      };

      wireplumber = {
        enable = true;

        extraConfig = {
          profiles = {
            main = {
              "monitor.libcamera" = "disabled";
              "monitor.channel-volumes" = true;
            };
          };

          bluetoothEnhancements = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
            };
          };
        };
      };

      alsa = {
        enable = true;
        support32Bit = true;
      };

      jack = { enable = true; };

      pulse = { enable = true; };
    };
  };

  environment = { systemPackages = with pkgs; [ pavucontrol ]; };
}
