{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  imports = [
    ./autoupgrade
    ./cachix
    ./channels
    ./features
    ./gc
    ./lang
    ./manix
    ./nh
    ./pkgs
    ./store
  ];

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;

    settings = {
      allowed-users = [
        "root"
        "@wheel"
      ];

      trusted-users = config.nix.settings.allowed-users ++ [ user ];

      sandbox = true;
    };
  };
}
