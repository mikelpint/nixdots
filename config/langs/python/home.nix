{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      python3Full
      python3Packages.tkinter
    ];
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals (builtins.any (
        x:
        builtins.match "^${(lib.getName pkgs.python)}(27?|3[0-9]*)?(Full)?$" (
          if lib.attrsets.isDerivation x then lib.getName x else null
        ) != null
      ) config.home.packages) [ "python" ];
    };
  };
}
