{
  nix = {
    settings = {
      auto-optimise-store = true;
    };
  };

  boot = {
    readOnlyNixStore = true;
  };
}
