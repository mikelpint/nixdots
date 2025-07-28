{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "aseprite" ];
    };
  };

  home = {
    packages = with pkgs; [ aseprite ];
  };
}
