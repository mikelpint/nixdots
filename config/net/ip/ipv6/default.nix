{ config, lib, ... }: {
  networking = { enableIPv6 = false; };
  boot = (lib.mkIf (!(config.networking.enableIpv6 or false))) {
    kernelParams = [ "ipv6.disable=1" ];
  };
}
