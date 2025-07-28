{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  services = {
    kmscon = {
      enable = lib.mkDefault false;
      # hwRender = lib.mkDefault (config.hardware.graphics.enable or false);
      autologinUser = lib.mkDefault user;
      fonts = [
        {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
      extraConfig = ''
        term=xterm-256color

        font-engine=pango
        font-size=14
        font-dpi=${toString (config.services.xserver.dpi or 96)}

        ${
          # black         => surface1
          # red           => red
          # green         => green
          # yellow        => peach
          # blue          => blue
          # magenta       => mauve
          # cyan          => teal
          # light-grey    => overlay2
          # dark-grey     => overlay1
          # light-red     => maroon
          # light-green   => green
          # light-yellow  => yellow
          # light-blue    => sapphire
          # light-magenta => pink
          # light-cyan    => sky
          # white         => subtext1
          # foreground    => text
          # background    => base
          lib.optionalString config.catppuccin.enable ''
            palette=custom
            ${lib.optionalString (config.catppuccin.flavor == "frappe") ''
              palette-black=81, 87, 109
              palette-red=231, 130, 132
              palette-green=166, 209, 144
              palette-yellow=239, 159, 118
              palette-blue=140, 170, 238
              palette-magenta=202, 158, 230
              palette-cyan=129, 200, 190
              palette-light-grey=148, 156, 187
              palette-dark-grey=131, 139, 167
              palette-light-red=234, 153, 156
              palette-light-green=166, 209, 144
              palette-light-yellow=229, 200, 144
              palette-light-blue=133, 193, 220
              palette-light-magenta=244, 184, 228
              palette-light-cyan=153, 209, 219
              palette-white=181, 191, 226
              palette-foreground=198, 208, 245
              palette-background=48, 52, 70
            ''}
            ${lib.optionalString (config.catppuccin.flavor == "latte") ''
              palette-black=188, 192, 204
              palette-red=210, 15, 57
              palette-green=64, 160, 43
              palette-yellow=254, 100, 11
              palette-blue=30, 102, 245
              palette-magenta=136, 57, 239
              palette-cyan=23, 146, 153
              palette-light-grey=124, 127, 147
              palette-dark-grey=140, 143, 161
              palette-light-red=230, 69, 83
              palette-light-green=64, 160, 43
              palette-light-yellow=223, 142, 29
              palette-light-blue=32, 159, 181
              palette-light-magenta=230, 69, 83
              palette-light-cyan=4, 165, 229
              palette-white=92, 95, 119
              palette-foreground=76, 79, 105
              palette-background=239, 241, 245
            ''}
            ${lib.optionalString (config.catppuccin.flavor == "macchiato") ''
              palette-black=73, 77, 100
              palette-red=54, 58, 79
              palette-green=166, 218, 149
              palette-yellow=245, 169, 127
              palette-blue=138, 173, 244
              palette-magenta=198, 160, 246
              palette-cyan=139, 213, 202
              palette-light-grey=147, 154, 183
              palette-dark-grey=128, 135, 162
              palette-light-red=238, 153, 160
              palette-light-green=166, 218, 149
              palette-light-yellow=238, 212, 159
              palette-light-blue=125, 196, 228
              palette-light-magenta=245, 189, 230
              palette-light-cyan=145, 215, 227
              palette-white=184, 192, 224
              palette-foreground=202, 211, 245
              palette-background=36, 39, 58
            ''}
            ${lib.optionalString (config.catppuccin.flavor == "mocha") ''
              palette-black=69, 71, 90
              palette-red=243, 139, 168
              palette-green=166, 227, 161
              palette-yellow=250, 179, 135
              palette-blue=137, 180, 250
              palette-magenta=203, 166, 247
              palette-cyan=148, 226, 213
              palette-light-grey=147, 153, 178
              palette-dark-grey=127, 132, 156
              palette-light-red=235, 160, 172
              palette-light-green=166, 227, 161
              palette-light-yellow=249, 226, 175
              palette-light-blue=116, 199, 236
              palette-light-magenta=245, 194, 231
              palette-light-cyan=137, 220, 235
              palette-white=186, 194, 222
              palette-foreground=205, 214, 244
              palette-background=30, 30, 46
            ''}
          ''
        }
      '';
      extraOptions = lib.mkDefault "--gpus all --render-engine ${
        if (config.hardware.graphics.enable or false) then "gltex" else "pixman"
      }";
    };
  };
}
