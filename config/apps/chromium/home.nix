{ pkgs, ... }:
let
  package = pkgs.chromium;
in
{
  programs = {
    chromium = {
      enable = true;
      inherit package;
    };
  };

  xdg = {
    configFile = {
      "chromium/NativeMessagingHosts/eu.webeid.json" = {
        source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
      };

      "google-chrome/NativeMessagingHosts/eu.webeid.json" = {
        source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
      };
    };
  };
}
