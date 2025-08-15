{ lib, ... }:
{
  programs = lib.mkIf false {
    ccache = {
      packageNames = [
        "electron"
        "electron-unwrapped"
      ];
    };
  };

  nixpkgs = lib.mkIf false {
    config = {
      electron = {
        pulseaudio = false;
      };

      electron-unwrapped = {
        pulseaudio = false;
      };
    };
  };
}
