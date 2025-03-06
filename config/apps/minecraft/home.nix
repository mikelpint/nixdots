{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      minecraft
      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];
        jdks = [
          jdk8
          jdk21
          jdk22

          jetbrains.jdk
        ];
      })
    ];
  };
}
