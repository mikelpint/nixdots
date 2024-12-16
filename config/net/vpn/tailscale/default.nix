{
  lib,
  config,
  pkgs,
  ...
}:
let
  interfaceName = "tailscale0";
in
{
  services = {
    tailscale = lib.mkDefault {
      enable = true;
      package = pkgs.tailscale;

      port = lib.mkDefault 0;
      inherit interfaceName;

      openFirewall = false;
      useRoutingFeatures = "none";

      authKeyFile = "/run/secrets/tailscale_key";
      permitCertUid = "mikel";
    };
  };

  networking = lib.mkIf config.services.tailscale.enable {
    firewall = {
      trustedInterfaces = [ interfaceName ];
    };
  };
}
