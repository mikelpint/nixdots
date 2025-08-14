_: {
  programs = {
    ccache = {
      packageNames = [
        "electron"
        "electron-unwrapped"
      ];
    };
  };

  nixpkgs = {
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
