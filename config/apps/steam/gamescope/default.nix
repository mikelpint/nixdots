_: {
  imports = [ ../../../security/bwrap ];

  programs = {
    gamescope = {
      enable = true;
      capSysNice = false;

      env = {
        # DISPLAY = "";
        # MANGOHUD = "0";
      };

      args = [
        "-e"
        "-S fit"
        "--sdr-gamut-wideness"
        "--adaptive-sync"
        "--mangoapp"
        "--rt"
        "--backend wayland"
        "--expose-wayland"
        "--steam"
      ];
    };

    steam = {
      gamescopeSession = {
        enable = true;
      };
    };
  };
}
