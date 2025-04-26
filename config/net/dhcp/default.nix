{ lib, config, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;

    dhcpcd = {
      enable = config.networking.useDHCP;
      persistent = true;

      wait = "background";
      extraConfig = ''
        noarp
      '';
    };
  };
}
