{ pkgs, ... }:
let
  inherit (pkgs) minecraft;
  prism = with pkgs; (prismlauncher.override {
    additionalPrograms = [ ffmpeg ];
    jdks = [
      jdk8
      jdk21
      jdk22

      jetbrains.jdk
    ];
  });
in {
  home = {
    packages = [
      minecraft
      prism
    ];
  };
}
