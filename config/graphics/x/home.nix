{ lib, config, ... }:
{
  xresources = {
    properties = lib.mkIf config.catppuccin.enable (
      # https://github.com/catppuccin/xresources/blob/41afcd788311ea2fce124029d9a02e2d65e0b3e6/themes/frappe.Xresources
      if config.catppuccin.flavor == "frappe" then
        {
          "background" = "#303446";
          "foreground" = "#c6d0f5";
          "cursorColor" = "#f2d5cf";

          "color0" = "#51576d";
          "color8" = "#626880";

          "color1" = "#e78284";
          "color9" = "#e78284";

          "color2" = "#a6d189";
          "color10" = "#a6d189";

          "color3" = "#e5c890";
          "color11" = "#e5c890";

          "color4" = "#8caaee";
          "color12" = "#8caaee";

          "color5" = "#f4b8e4";
          "color13" = "#f4b8e4";

          "color6" = "#81c8be";
          "color14" = "#81c8be";

          "color7" = "#b5bfe2";
          "color15" = "#a5adce";
        }

      # https://github.com/catppuccin/xresources/blob/41afcd788311ea2fce124029d9a02e2d65e0b3e6/themes/latte.Xresources
      else if config.catppuccin.flavor == "latte" then
        {
          "background" = "#eff1f5";
          "foreground" = "#4c4f69";
          "cursorColor" = "#dc8a78";

          "color0" = "#5c5f77";
          "color8" = "#6c6f85";

          "color1" = "#d20f39";
          "color9" = "#d20f39";

          "color2" = "#40a02b";
          "color10" = "#40a02b";

          "color3" = "#df8e1d";
          "color11" = "#df8e1d";

          "color4" = "#1e66f5";
          "color12" = "#1e66f5";

          "color5" = "#ea76cb";
          "color13" = "#ea76cb";

          "color6" = "#179299";
          "color14" = "#179299";

          "color7" = "#acb0be";
          "color15" = "#bcc0cc";
        }

      # https://github.com/catppuccin/xresources/blob/41afcd788311ea2fce124029d9a02e2d65e0b3e6/themes/macchiato.Xresources
      else if config.catppuccin.flavor == "macchiato" then
        {
          "*background" = "#24273a";
          "*foreground" = "#cad3f5";
          "*cursorColor" = "#f4dbd6";

          "*color0" = "#494d64";
          "*color8" = "#5b6078";

          "*color1" = "#ed8796";
          "*color9" = "#ed8796";

          "*color2" = "#a6da95";
          "*color10" = "#a6da95";

          "*color3" = "#eed49f";
          "*color11" = "#eed49f";

          "*color4" = "#8aadf4";
          "*color12" = "#8aadf4";

          "*color5" = "#f5bde6";
          "*color13" = "#f5bde6";

          "*color6" = "#8bd5ca";
          "*color14" = "#8bd5ca";

          "*color7" = "#b8c0e0";
          "*color15" = "#a5adcb";
        }

      # https://github.com/catppuccin/xresources/blob/41afcd788311ea2fce124029d9a02e2d65e0b3e6/themes/mocha.Xresources
      else
        {
          "background" = "#1e1e2e";
          "foreground" = "#cdd6f4";
          "cursorColor" = "#f5e0dc";

          "color0" = "#45475a";
          "color8" = "#585b70";

          "color1" = "#f38ba8";
          "color9" = "#f38ba8";

          "color2" = "#a6e3a1";
          "color10" = "#a6e3a1";

          "color3" = "#f9e2af";
          "color11" = "#f9e2af";

          "color4" = "#89b4fa";
          "color12" = "#89b4fa";

          "color5" = "#f5c2e7";
          "color13" = "#f5c2e7";

          "color6" = "#94e2d5";
          "color14" = "#94e2d5";

          "color7" = "#bac2de";
          "color15" = "#a6adc8";
        }
    );
  };
}
