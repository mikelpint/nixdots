{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    foot = {
      enable = true;
      package = pkgs.foot;

      server = {
        enable = lib.mkDefault false;
      };

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=13";
          pad = "7x7";
        };

        scrollback = {
          lines = 10000;
        };

        cursor = {
          style = "block";
          blink = "no";
        };
      };
    };
  };

  catppuccin = {
    foot = {
      inherit (config.catppuccin) enable flavor;
    };
  };
}
