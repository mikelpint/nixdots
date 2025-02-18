{ pkgs, lib, user, ... }: {
  environment = { systemPackages = with pkgs; [ bubblewrap ]; };

  security = {
    wrappers = {
      bwrap = {
        owner = user;
        group = user;
        source = builtins.toPath "${pkgs.bubblewrap}/bin/bwrap";
        setuid = lib.mkForce true;
        # capabilities = "all+eip";
      };
    };
  };

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

    steam = { gamescopeSession = { enable = true; }; };
  };
}
