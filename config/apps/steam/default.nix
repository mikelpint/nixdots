{ pkgs, ... }:
{
  imports = [ ./gamescope ];

  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs =
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
              keyutils
            ];
        };
      };
    };
  };

  programs = {
    steam = {
      extraCompatPackages = with pkgs; [ proton-ge-bin ];

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
