{
  lib,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../../boot/kernel/realtime

    ../jack

    ./das_watchdog
    ./rtcqs
    ./rtirq
    ./rtkit
  ];

  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "performance";
  };

  security = {
    pam = {
      loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
      ];
    };
  };

  services = {
    udev = {
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };
  };

  boot = {
    kernel = {
      sysctl = {
        "vm.swappiness" = lib.mkDefault 10;
        "fs.inotify.max_user_watches" = lib.mkOverride 900 524288;
      };
    };

    kernelParams = [ "threadirqs" ];

    postBootCommands = ''
      echo 2048 > /sys/class/rtc/rtc0/max_user_freq
      echo 2048 > /proc/sys/dev/hpet/max-user-freq
      ${pkgs.pciutils}/bin/setpci -v -d *:* latency_timer=b0
    '';
  };

  environment = {
    sessionVariables =
      let
        makePluginPathVar =
          plugin:
          "/home/${user}/.${plugin}:${
            lib.makeSearchPath plugin [
              "/home/${user}/.nix-profile/lib"
              "/run/current-system/sw/lib"
              "/etc/profiles/per-user/${user}/lib"
              "/nix/var/nix/profiles/default/lib"
              "/var/run/current-system/sw/lib"
            ]
          }";
      in
      {
        CLAP_PATH = lib.mkDefault (makePluginPathVar "clap");
        DSSI_PATH = lib.mkDefault (makePluginPathVar "dssi");
        LADSPA_PATH = lib.mkDefault (makePluginPathVar "ladspa");
        LV2_PATH = lib.mkDefault (makePluginPathVar "lv2");
        LXVST_PATH = lib.mkDefault (makePluginPathVar "lxvst");
        VST3_PATH = lib.mkDefault (makePluginPathVar "vst3");
        VST_PATH = lib.mkDefault (makePluginPathVar "vst");
      };
  };
}
