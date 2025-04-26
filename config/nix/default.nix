_: {
  imports = [
    ./autoupgrade
    ./cachix
    ./features
    ./gc
    ./lang
    ./manix
    ./pkgs
    ./store
  ];

  nix = {
    settings = {
      allowed-users = [
        "@wheel"
        "root"
      ];
    };
  };
}
