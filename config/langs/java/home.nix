{ pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      jetbrains.jdk

      maven
    ];

    sessionVariables = {
      _JAVA_OPTIONS = lib.mkDefault "-Dawt.useSystemAAFontSettings=lcd";
    };
  };
}
