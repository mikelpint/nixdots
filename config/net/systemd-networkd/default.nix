{ lib, config, ... }:
{
  systemd = {
    network = {
      enable = lib.mkDefault false;
      wait-online = {
        enable = lib.mkDefault false;
      };

      config = {
        networkConfig = {
          IPv6PrivacyExtensions = "kernel";
        };
      };
    };
  };

  networking = {
    useNetworkd = false;
  };
}
