{ lib, ... }:
{
  imports = [ ./memtest86 ];

  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault false;
        editor = lib.mkDefault false;
      };
    };
  };
}
