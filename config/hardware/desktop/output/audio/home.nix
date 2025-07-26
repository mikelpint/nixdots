{
  config,
  lib,
  ...
}:
{
  imports = [
    (import ../../../common/output/audio/home.nix {
      inherit config;
      inherit lib;
      id = null;
    })
  ];
}
