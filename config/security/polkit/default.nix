{ user, ... }:
{
  imports = [ ./rules ];

  security = {
    polkit = {
      enable = true;
      adminIdentities = [
        "unix-group:wheel"
        "unix-user:${user}"
      ];
    };
  };
}
