{ pkgs, ... }:
{
  imports = [ ./gamescope ];

  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
            RADV_TEX_ANISO = 16;
          };

          extraPkgs =
            pkgs: with pkgs; [
              keyutils
              steamcontroller
            ];

          extraLibraries =
            pkgs: with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              atk
            ];

          privateTmp = true;

        };
      };
    };

    overlays = [
      (_self: super: {
        steam = super.steam.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall =
            (old.postInstall or "")
            + ''
              substituteInPlace $out/share/applications/slack.desktop \
                      --replace "PrefersNonDefaultGPU=true" "PrefersNonDefaultGPU=false"
            '';
        });
      })
    ];
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam;

      extraCompatPackages = with pkgs; [ proton-ge-bin ];

      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };

      extest = {
        enable = true;
      };

      remotePlay = {
        openFirewall = false;
      };

      dedicatedServer = {
        openFirewall = true;
      };

      localNetworkGameTransfers = {
        openFirewall = false;
      };
    };
  };
}
