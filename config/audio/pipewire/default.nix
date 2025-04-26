{ pkgs, ... }:
{
  services = {
    pipewire = {
      enable = true;

      extraConfig = {
        pipewire = {
          "10-easyeffects-sink" = {
            "context.objects" = [
              {
                factory = "adapter";
                args = {
                  "factory.name" = "support.null-audio-sink";
                  "node.name" = "easyeffects_sink";
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                    "FC"
                    "LFE"
                    "RL"
                    "RR"
                  ];
                  "monitor.channel-volumes" = true;
                  "monitor.passthrough" = true;
                  "adapter.auto-port-config" = {
                    mode = "dsp";
                    monitor = true;
                    position = "preserve";
                  };
                };
              }
            ];
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
              "monitor.bluez.seat-monitoring" = "enabled";
            };
          };

          bluetoothEnhancements = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.hfphsp-backend" = "native";
              "bluez5.roles" = [
                "a2dp_sink"
                "a2dp_source"
                "bap_sink"
                "bap_source"
                "hsp_hs"
                "hsp_ag"
                "hfp_hf"
                "hfp_ag"
              ];
              "bluez5.codecs" = [
                "sbc"
                "sbc_xq"
                "aac"
                "ldac"
                "aptx"
                "aptx_hd"
                "aptx_ll"
                "aptx_ll_duplex"
                "faststream"
                "faststream_duplex"
                "lc3plus_h3"
                "opus_05"
                "opus_05_51"
                "opus_05_71"
                "opus_05_duplex"
                "opus_05_pro"
                "lc3"
              ];
              "bluez5.default.rate" = 48000;
              "bluez5.default.channels" = 2;
              "bluez5.a2dp.opus.pro.channels" = 3;
              "bluez5.a2dp.opus.pro.coupled-streams" = 1;
              "bluez5.a2dp.opus.pro.locations" = [
                "FL"
                "FR"
                "LFE"
              ];
              "bluez5.a2dp.opus.pro.max-bitrate" = 600000;
              "bluez5.a2dp.opus.pro.frame-dms" = 50;
              "bluez5.a2dp.opus.pro.bidi.channels" = 1;
              "bluez5.a2dp.opus.pro.bidi.coupled-streams" = 0;
              "bluez5.a2dp.opus.pro.bidi.locations" = [ "FC" ];
              "bluez5.a2dp.opus.pro.bidi.max-bitrate" = 160000;
              "bluez5.a2dp.opus.pro.bidi.frame-dms" = 400;
            };
          };
        };
      };

      alsa = {
        enable = true;
        support32Bit = true;
      };

      jack = {
        enable = true;
      };

      pulse = {
        enable = true;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ pavucontrol ];
  };
}
