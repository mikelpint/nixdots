{ pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [ bubblewrap ];
  };

  #security = {
  #  wrappers = {
  #    bwrap = {
  #      owner = "mikel";
  #      group = "mikel";
  #      source = builtins.toPath "${pkgs.bubblewrap}/bin/bwrap";
  #      setuid = lib.mkForce true;
  #      #capabilities = "all+eip";
  #    };
  #  };
  #};

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      gamescopeSession = {
        enable = true;
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
