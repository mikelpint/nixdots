{ pkgs, inputs, ... }:
{
  programs = {
    mangohud = {
      settingsPerApplication = {
        wezterm = {
          no_display = true;
        };
      };
    };
  };

  home = {
    packages =
      with pkgs;
      with inputs.nix-gaming.packages.${pkgs.system};
      [
        (steam.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
            RADV_TEX_ANISO = 16;
          };

          extraPkgs = _pkgs: [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
        })

        protonup

        wine-discord-ipc-bridge
        # wine-ge
      ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
