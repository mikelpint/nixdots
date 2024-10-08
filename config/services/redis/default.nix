{
  services = {
    redis = {
      vmOverCommit = true;

      servers = {
        "" = {
          enable = true;

          port = 6379;
          openFirewall = false;
          bind = "127.0.0.1";

          save = [ ];

          user = "redis";
        };
      };
    };
  };
}
