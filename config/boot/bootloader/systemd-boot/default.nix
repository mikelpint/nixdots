{ lib, config, ... }:
{
  imports = [ ./memtest86 ];

  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;

        configurationLimit = lib.mkDefault 50;
        sortKey = lib.mkDefault "nixos";

        editor = lib.mkDefault false;

        consoleMode = lib.mkDefault "keep";

        installDeviceTree = with config.hardware.deviceTree; lib.mkDefault (enable && name != null);

        edk2-uefi-shell = {
          enable = lib.mkDefault false;
          sortKey = "o_edk2-uefi-shell";
        };

        netbootxyz = {
          enable = lib.mkDefault false;
          sortKey = lib.mkDefault "o_netbootxyz";
        };
      };
    };
  };
}
