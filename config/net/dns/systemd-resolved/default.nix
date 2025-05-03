{
  lib,
  ...
}:
{
  services = {
    resolved = {
      enable = lib.mkDefault true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      dnsovertls = "true";
      llmnr = "true";
      extraConfig = ''
        MulticastDNS=true
      '';
    };
  };
}
