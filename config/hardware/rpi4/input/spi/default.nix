{ lib, config, ... }:
{
  hardware =
    lib.mkIf config.users.groups.spi != null {
      deviceTree = {
        overlays = [
          {
            name = "spi";
            dtboFile = ./spi0-0cs.dtbo;
          }
        ];
      };
    };

  users = {
    groups = {
      spi = { };
    };
  };

  services =
    lib.mkIf config.users.groups.spi != null {
      udev = {
        extraRules = ''
          SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
        '';
      };
    };
}
