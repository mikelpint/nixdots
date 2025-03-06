{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ jetbrains.jdk ];

    sessionVariables = { _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd"; };
  };
}
