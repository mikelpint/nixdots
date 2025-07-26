{ pkgs, ... }:
{
  programs = {
    fastfetch = {
      enable = true;
      package = pkgs.fastfetch;

      settings = {
        display = {
          color = "white";

          key = {
            width = 6;
          };

          percent = {
            color = {
              green = "white";
              red = "white";
              yellow = "white";
            };
          };
          separator = "";
        };

        logo = {
          source = "NixOs";
          type = "builtin";
        };

        modules = [
          {
            key = "╭ ";
            type = "board";
          }

          {
            key = "├ ";
            type = "cpu";
          }

          {
            key = "├ ";
            type = "memory";
          }

          {
            key = "├ ";
            type = "gpu";
          }

          {
            folders = "/";
            key = "├ ";
            type = "disk";
          }

          {
            key = "├ ";
            type = "battery";
          }

          {
            key = "├ ﮣ";
            type = "poweradapter";
          }

          {
            compactType = "original-with-refresh-rate";
            key = "╰ 󱡶";
            type = "display";
          }

          "break"

          {
            key = "╭ ";
            type = "os";
          }

          {
            key = "├ ";
            type = "kernel";
          }

          {
            key = "├ ";
            type = "wm";
          }

          {
            key = "├ ";
            type = "shell";
          }

          {
            key = "├ ";
            type = "terminal";
          }

          {
            key = "├ ";
            type = "packages";
          }

          {
            key = "╰ ";
            type = "uptime";
          }

          "break"

          {
            symbol = "circle";
            type = "colors";
          }
        ];
      };
    };
  };
}
