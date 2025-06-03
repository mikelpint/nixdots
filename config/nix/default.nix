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
