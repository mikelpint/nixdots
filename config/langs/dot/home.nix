{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      graphviz
      dot2tex
      gprof2dot
      pycflow2dot
    ];
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.graphviz)
        ) config.home.packages) [ "graphviz" ];
    };
  };
}
