{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [ pkl ];
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals (builtins.any (
        x: (lib.getName x) == (lib.getName pkgs.pkl)
      ) config.home.packages) [ "pkl" ];
    };
  };
}
