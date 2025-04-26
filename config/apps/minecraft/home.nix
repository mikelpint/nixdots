{ pkgs, ... }:
let
  prism =
    with pkgs;
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        jdk8
        jdk23

        jetbrains.jdk
      ];
    });
in
{
  home = {
    packages = [
      # minecraft
      prism
    ];
  };
}
