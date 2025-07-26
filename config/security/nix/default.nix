{
  nix = {
    settings = {
      allowed-users = [
        "@wheel"
        "root"
      ];
    };
  };

  environment = {
    defaultPackages = [ ];
  };
}
