{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      jetbrains.jdk

      maven
      gradle
    ];

    sessionVariables = {
      _JAVA_OPTIONS = lib.mkDefault "-Dawt.useSystemAAFontSettings=lcd";
    };
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals (builtins.any (
        x:
        builtins.match "^${(lib.getName pkgs.jdk)}([0-9]+)?(_headless)?$" (
          if lib.attrsets.isDerivation x then lib.getName x else null
        ) != null
      ) config.home.packages) [ "java" ];
    };
  };
}
