{ user, ... }:
{
  nix = {
    settings = {
      allowed-users = [
        "@wheel"
        "root"
        user
      ];
    };
  };

  environment = {
    defaultPackages = [ ];
  };
}
