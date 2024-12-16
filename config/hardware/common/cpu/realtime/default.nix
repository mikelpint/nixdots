_: {
  users = {
    users = {
      mikel = {
        extraGroups = [ "realtime" ];
      };
    };

    groups = {
      realtime = { };
    };
  };

  services = {
    udev = {
      extraRules = ''
        KERNEL=="cpu_dma_latency", GROUP="realtime"
      '';
    };
  };

  security = {
    pam = {
      loginLimits = [
        {
          domain = "@realtime";
          type = "-";
          item = "rtprio";
          value = 98;
        }
        {
          domain = "@realtime";
          type = "-";
          item = "memlock";
          value = "unlimited";
        }
        {
          domain = "@realtime";
          type = "-";
          item = "nice";
          value = -11;
        }
      ];
    };
  };
}
