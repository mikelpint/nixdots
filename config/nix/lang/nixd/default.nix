{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment = {
    systemPackages = lib.optionals (config.lix.enable or false) (
      with pkgs;
      [
        nixd
      ]
    );
  };
}
