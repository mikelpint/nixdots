{pkgs, config, ...}:
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
  programs = {
    firejail = {
      minecraft = {
        executable = "${minecraft}/bin/minecraft-launcher";
        profile = "${config.programs.firejail.package}/etc/firejail/minecraft-launcher.profile";
      };

      prismlauncher = {
        executable = "${prism}/bin/prismlauncher";
        profile = "${config.programs.firejail.package}/etc/firejail/prismlauncher.profile";
      };
    };
  };
}
