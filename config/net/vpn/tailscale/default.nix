{ lib, config, pkgs, self, user, ... }:
let interfaceName = "tailscale0";
in {
  services = {
    tailscale = lib.mkDefault {
      enable = true;
      package = pkgs.tailscale;

      port = 0;
      inherit interfaceName;

      openFirewall = false;
      useRoutingFeatures = "none";

      authKeyFile = "${self}/secrets/tailscale.age";
      permitCertUid = user;
    };
  };

  networking = lib.mkIf config.services.tailscale.enable {
    firewall = { trustedInterfaces = [ interfaceName ]; };
  };
}
