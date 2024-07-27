{ pkgs, lib, ... }: {
  programs = {
    firejail = {
      enable = true;

      wrappingBinaries = {
        discord = {
          executable = "${lib.getBin pkgs.discord}/bin/discord";
          profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        };

        httpie = {
          executable = "${lib.getBin pkgs.httpie}/bin/http";
          profile = "${pkgs.firejail}/etc/firejail/httpie.profile";
        };

        imv = {
          executable = "${lib.getBin pkgs.imv}/bin/imv";
          profile = "${pkgs.firejail}/etc/firejail/imv.profile";
        };

        insomnia = {
          executable = "${lib.getBin pkgs.insomnia}/bin/insomnia";
          profile = "${pkgs.firejail}/etc/firejail/insomnia.profile";
        };

        intellij-idea = {
          executable = "${lib.getBin pkgs.jetbrains.idea-ultimate}/bin/idea.sh";
          profile = "${pkgs.firejail}/etc/firejail/intellij-idea.profile";
        };

        intellij-clion = {
          executable = "${lib.getBin pkgs.jetbrains.clion}/bin/clion.sh";
          profile = "${pkgs.firejail}/etc/firejail/intellij-clion.profile";
        };

        firefox = {
          executable = "${lib.getBin pkgs.firefox}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };

        floorp = {
          executable = "${lib.getBin pkgs.floorp}/bin/floorp";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };

        mpv = {
          executable = "${lib.getBin pkgs.mpv}/bin/mpv";
          profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
        };

        mongodb-compass = {
          executable = "${lib.getBin pkgs.mongodb-compass}/bin/mongodb-compass";
          profile = "${pkgs.firejail}/etc/firejail/mongodb-compass.profile";
        };

        skype = {
          executable = "${lib.getBin pkgs.skypeforlinux}/bin/skypeforlinux";
          profile = "${pkgs.firejail}/etc/firejail/skype.profile";
        };

        steam = {
          executable = "${lib.getBin pkgs.steam}/bin/steam";
          profile = "${pkgs.firejail}/etc/firejail/steam.profile";
        };

        tor-browser = {
          executable = "${lib.getBin pkgs.tor-browser-bundle}/bin/tor-browser";
          profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
        };

        vscode = {
          executable = "${lib.getBin pkgs.vscode}/bin/code";
          profile = "${pkgs.firejail}/etc/firejail/vscode.profile";
        };

        zathura = {
          executable = "${lib.getBin pkgs.zathura}/bin/zathura";
          profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
        };

        zed = {
          executable = "${lib.getBin pkgs.zed-editor}/bin/zed";
          profile = "${pkgs.firejail}/etc/firejail/zed.profile";
        };
      };
    };
  };
}
