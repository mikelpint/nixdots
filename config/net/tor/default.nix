{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    services = {
      tor = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.tor;

        openFirewall = lib.mkDefault config.services.tor.relay.enable;

        enableGeoIP = lib.mkDefault true;

        torsocks = {
          enable = true;
          server = "127.0.0.1:9050";
        };

        relay = {
          enable = false;
        };

        client = {
          enable = true;
        };

        settings = {
          Nickname = "mikelpint";
          ContactInfo = "mikelpint@protonmail.com";

          ExitPolicy = [ "accept *:*" ];

          CookieAuthentication = true;
          AvoidDiskWrites = 1;
          HardwareAccel = 1;
          SafeLogging = 1;
          NumCPUs = lib.mkDefault 1;

          HiddenServiceStatistics = false;
          HiddenServiceNonAnonymousMode = lib.mkDefault false;
        };
      };
    };

    assertions = [
      {
        assertion =
          !(config.services.tor.HiddenServiceNonAnonymousMode or false)
          || (
            (config.services.tor.HiddenServiceNonAnonymousMode or false)
            && (
              config.services.tor.client.enable
              || (
                config.services.tor.torsocks.enable
                && (
                  config.services.tor.torsocks.server == "0.0.0.0"
                  || builtins.match ":0$" config.services.tor.torsocks.server
                )
              )
            )
          );
        message = "You need to disable all client-side services on your Tor instance, including setting SOCKSPort to \"0\".";
      }
    ];
  };
}
