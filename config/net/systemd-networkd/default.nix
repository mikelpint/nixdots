{ lib, ... }:
{
  systemd = {
    network = {
      enable = lib.mkDefault false;
      wait-online = {
        enable = false;
      };

      config = {
        networkConfig = {
          IPv6PrivacyExtensions = "kernel";
        };
      };
    };
  };
}
