{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    wofi = {
      enable = true;
      package = pkgs.wofi;

      settings = {
        show = "drun";
        exec-search = true;
        width = 600;
        height = 400;
        orientation = "vertical";
        halign = "fill";
        content_halign = "fill";
        allow_markup = "true";
        always_parse_args = "true";
        show_all = false;
        term = "xdg-terminal-exec";
        hide_scroll = true;
        print_command = true;
        insensitive = true;
        allow_images = true;
        prompt = "";
        columns = 2;
      };

      style =
        let
          inherit
            (config.catppuccin or {
              enable = false;
              flavor = "mocha";
              accent = "mauve";
            }
            )
            enable
            flavor
            accent
            ;
        in
        lib.optionalString enable ''
            ${lib.optionalString (flavor == "frappe") ''
              @define-color rosewater      #f2d5cf;
              @define-color rosewater-rgb  rgb(242, 213, 207);
              @define-color flamingo       #eebebe;
              @define-color flamingo-rgb   rgb(238, 190, 190);
              @define-color pink           #f4b8e4;
              @define-color pink-rgb       rgb(244, 184, 228);
              @define-color mauve          #ca9ee6;
              @define-color mauve-rgb      rgb(202, 158, 230);
              @define-color red            #e78284;
              @define-color red-rgb        rgb(231, 130, 132);
              @define-color maroon         #ea999c;
              @define-color maroon-rgb     rgb(234, 153, 156);
              @define-color peach          #ef9f76;
              @define-color peach-rgb      rgb(239, 159, 118);
              @define-color yellow         #e5c890;
              @define-color yellow-rgb     rgb(229, 200, 144);
              @define-color green          #a6d189;
              @define-color green-rgb      rgb(166, 209, 137);
              @define-color teal           #81c8be;
              @define-color teal-rgb       rgb(129, 200, 190);
              @define-color sky            #99d1db;
              @define-color sky-rgb        rgb(153, 209, 219);
              @define-color sapphire       #85c1dc;
              @define-color sapphire-rgb   rgb(133, 193, 220);
              @define-color blue           #8caaee;
              @define-color blue-rgb       rgb(140, 170, 238);
              @define-color lavender       #babbf1;
              @define-color lavender-rgb   rgb(186, 187, 241);
              @define-color text           #c6d0f5;
              @define-color text-rgb       rgb(198, 208, 245);
              @define-color subtext1       #b5bfe2;
              @define-color subtext1-rgb   rgb(181, 191, 226);
              @define-color subtext0       #a5adce;
              @define-color subtext0-rgb   rgb(165, 173, 206);
              @define-color overlay2       #949cbb;
              @define-color overlay2-rgb   rgb(148, 156, 187);
              @define-color overlay1       #838ba7;
              @define-color overlay1-rgb   rgb(131, 139, 167);
              @define-color overlay0       #737994;
              @define-color overlay0-rgb   rgb(115, 121, 148);
              @define-color surface2       #626880;
              @define-color surface2-rgb   rgb(98, 104, 128);
              @define-color surface1       #51576d;
              @define-color surface1-rgb   rgb(81, 87, 109);
              @define-color surface0       #414559;
              @define-color surface0-rgb   rgb(65, 69, 89);
              @define-color base           #303446;
              @define-color base-rgb       rgb(48, 52, 70);
              @define-color mantle         #292c3c;
              @define-color mantle-rgb     rgb(41, 44, 60);
              @define-color crust          #232634;
              @define-color crust-rgb      rgb(35, 38, 52);
            ''}

            ${lib.optionalString (flavor == "latte") ''
              @define-color rosewater      #dc8a78;
              @define-color rosewater-rgb  rgb(220, 138, 120);
              @define-color flamingo       #dd7878;
              @define-color flamingo-rgb   rgb(221, 120, 120);
              @define-color pink           #ea76cb;
              @define-color pink-rgb       rgb(234, 118, 203);
              @define-color mauve          #8839ef;
              @define-color mauve-rgb      rgb(136, 57, 239);
              @define-color red            #d20f39;
              @define-color red-rgb        rgb(210, 15, 57);
              @define-color maroon         #e64553;
              @define-color maroon-rgb     rgb(230, 69, 83);
              @define-color peach          #fe640b;
              @define-color peach-rgb      rgb(254, 100, 11);
              @define-color yellow         #df8e1d;
              @define-color yellow-rgb     rgb(223, 142, 29);
              @define-color green          #40a02b;
              @define-color green-rgb      rgb(64, 160, 43);
              @define-color teal           #179299;
              @define-color teal-rgb       rgb(23, 146, 153);
              @define-color sky            #04a5e5;
              @define-color sky-rgb        rgb(4, 165, 229);
              @define-color sapphire       #209fb5;
              @define-color sapphire-rgb   rgb(32, 159, 181);
              @define-color blue           #1e66f5;
              @define-color blue-rgb       rgb(30, 102, 245);
              @define-color lavender       #7287fd;
              @define-color lavender-rgb   rgb(114, 135, 253);
              @define-color text           #4c4f69;
              @define-color text-rgb       rgb(76, 79, 105);
              @define-color subtext1       #5c5f77;
              @define-color subtext1-rgb   rgb(92, 95, 119);
              @define-color subtext0       #6c6f85;
              @define-color subtext0-rgb   rgb(108, 111, 133);
              @define-color overlay2       #7c7f93;
              @define-color overlay2-rgb   rgb(124, 127, 147);
              @define-color overlay1       #8c8fa1;
              @define-color overlay1-rgb   rgb(140, 143, 161);
              @define-color overlay0       #9ca0b0;
              @define-color overlay0-rgb   rgb(156, 160, 176);
              @define-color surface2       #acb0be;
              @define-color surface2-rgb   rgb(172, 176, 190);
              @define-color surface1       #bcc0cc;
              @define-color surface1-rgb   rgb(188, 192, 204);
              @define-color surface0       #ccd0da;
              @define-color surface0-rgb   rgb(204, 208, 218);
              @define-color base           #eff1f5;
              @define-color base-rgb       rgb(239, 241, 245);
              @define-color mantle         #e6e9ef;
              @define-color mantle-rgb     rgb(230, 233, 239);
              @define-color crust          #dce0e8;
              @define-color crust-rgb      rgb(220, 224, 232);
            ''}

            ${lib.optionalString (flavor == "macchiato") ''
              @define-color rosewater      #f4dbd6;
              @define-color rosewater-rgb  rgb(244, 219, 214);
              @define-color flamingo       #f0c6c6;
              @define-color flamingo-rgb   rgb(240, 198, 198);
              @define-color pink           #f5bde6;
              @define-color pink-rgb       rgb(245, 189, 230);
              @define-color mauve          #c6a0f6;
              @define-color mauve-rgb      rgb(198, 160, 246);
              @define-color red            #ed8796;
              @define-color red-rgb        rgb(237, 135, 150);
              @define-color maroon         #ee99a0;
              @define-color maroon-rgb     rgb(238, 153, 160);
              @define-color peach          #f5a97f;
              @define-color peach-rgb      rgb(245, 169, 127);
              @define-color yellow         #eed49f;
              @define-color yellow-rgb     rgb(238, 212, 159);
              @define-color green          #a6da95;
              @define-color green-rgb      rgb(166, 218, 149);
              @define-color teal           #8bd5ca;
              @define-color teal-rgb       rgb(139, 213, 202);
              @define-color sky            #91d7e3;
              @define-color sky-rgb        rgb(145, 215, 227);
              @define-color sapphire       #7dc4e4;
              @define-color sapphire-rgb   rgb(125, 196, 228);
              @define-color blue           #8aadf4;
              @define-color blue-rgb       rgb(138, 173, 244);
              @define-color lavender       #b7bdf8;
              @define-color lavender-rgb   rgb(183, 189, 248);
              @define-color text           #cad3f5;
              @define-color text-rgb       rgb(202, 211, 245);
              @define-color subtext1       #b8c0e0;
              @define-color subtext1-rgb   rgb(184, 192, 224);
              @define-color subtext0       #a5adcb;
              @define-color subtext0-rgb   rgb(165, 173, 203);
              @define-color overlay2       #939ab7;
              @define-color overlay2-rgb   rgb(147, 154, 183);
              @define-color overlay1       #8087a2;
              @define-color overlay1-rgb   rgb(128, 135, 162);
              @define-color overlay0       #6e738d;
              @define-color overlay0-rgb   rgb(110, 115, 141);
              @define-color surface2       #5b6078;
              @define-color surface2-rgb   rgb(91, 96, 120);
              @define-color surface1       #494d64;
              @define-color surface1-rgb   rgb(73, 77, 100);
              @define-color surface0       #363a4f;
              @define-color surface0-rgb   rgb(54, 58, 79);
              @define-color base           #24273a;
              @define-color base-rgb       rgb(36, 39, 58);
              @define-color mantle         #1e2030;
              @define-color mantle-rgb     rgb(30, 32, 48);
              @define-color crust          #181926;
              @define-color crust-rgb      rgb(24, 25, 38);
            ''}

            ${lib.optionalString (flavor == "macchiato") ''
              @define-color rosewater      #f5e0dc;
              @define-color rosewater-rgb  rgb(245, 224, 220);
              @define-color flamingo       #f2cdcd;
              @define-color flamingo-rgb   rgb(242, 205, 205);
              @define-color pink           #f5c2e7;
              @define-color pink-rgb       rgb(245, 194, 231);
              @define-color mauve          #cba6f7;
              @define-color mauve-rgb      rgb(203, 166, 247);
              @define-color red            #f38ba8;
              @define-color red-rgb        rgb(243, 139, 168);
              @define-color maroon         #eba0ac;
              @define-color maroon-rgb     rgb(235, 160, 172);
              @define-color peach          #fab387;
              @define-color peach-rgb      rgb(250, 179, 135);
              @define-color yellow         #f9e2af;
              @define-color yellow-rgb     rgb(249, 226, 175);
              @define-color green          #a6e3a1;
              @define-color green-rgb      rgb(166, 227, 161);
              @define-color teal           #94e2d5;
              @define-color teal-rgb       rgb(148, 226, 213);
              @define-color sky            #89dceb;
              @define-color sky-rgb        rgb(137, 220, 235);
              @define-color sapphire       #74c7ec;
              @define-color sapphire-rgb   rgb(116, 199, 236);
              @define-color blue           #89b4fa;
              @define-color blue-rgb       rgb(137, 180, 250);
              @define-color lavender       #b4befe;
              @define-color lavender-rgb   rgb(180, 190, 254);
              @define-color text           #cdd6f4;
              @define-color text-rgb       rgb(205, 214, 244);
              @define-color subtext1       #bac2de;
              @define-color subtext1-rgb   rgb(186, 194, 222);
              @define-color subtext0       #a6adc8;
              @define-color subtext0-rgb   rgb(166, 173, 200);
              @define-color overlay2       #9399b2;
              @define-color overlay2-rgb   rgb(147, 153, 178);
              @define-color overlay1       #7f849c;
              @define-color overlay1-rgb   rgb(127, 132, 156);
              @define-color overlay0       #6c7086;
              @define-color overlay0-rgb   rgb(108, 112, 134);
              @define-color surface2       #585b70;
              @define-color surface2-rgb   rgb(88, 91, 112);
              @define-color surface1       #45475a;
              @define-color surface1-rgb   rgb(69, 71, 90);
              @define-color surface0       #313244;
              @define-color surface0-rgb   rgb(49, 50, 68);
              @define-color base           #1e1e2e;
              @define-color base-rgb       rgb(30, 30, 46);
              @define-color mantle         #181825;
              @define-color mantle-rgb     rgb(24, 24, 37);
              @define-color crust          #11111b;
              @define-color crust-rgb      rgb(17, 17, 27);
            ''}

          * {
            font-family: 'JetBrainsMono Nerd Font', monospace;
            font-size: 14px;
          }

          window {
            margin: 0px;
            padding: 10px;
            border: 0.16em solid @${accent};
            border-radius: 0.1em;
            background-color: @base;
            animation: slideIn 0.5s ease-in-out both;
          }

          @keyframes slideIn {
            0% {
              opacity: 0;
            }

            100% {
              opacity: 1;
            }
          }

          #inner-box {
            margin: 5px;
            padding: 10px;
            border: none;
            background-color: @base;
            animation: fadeIn 0.5s ease-in-out both;
          }

          @keyframes fadeIn {
            0% {
              opacity: 0;
            }

            100% {
              opacity: 1;
            }
          }

          #outer-box {
            margin: 5px;
            padding: 10px;
            border: none;
            background-color: @base;
          }

          #scroll {
            margin: 0px;
            padding: 10px;
            border: none;
            background-color: @base;
          }

          #input {
            margin: 5px 20px;
            padding: 10px;
            border: none;
            border-radius: 0.1em;
            box-shadow: none;
            color: @text;
            background-color: @base;
            animation: fadeIn 0.5s ease-in-out both;
          }

          #input image {
              border: none;
              color: @red;
          }

          #input * {
            outline: 4px solid @${accent}!important;
          }

          #text {
            margin: 5px;
            border: none;
            color: @text;
            animation: fadeIn 0.5s ease-in-out both;
          }

          #entry {
            background-color: @base;
          }

          #entry arrow {
            border: none;
            color: @${accent};
          }

          #entry:selected {
            border: 0.11em solid @${accent};
          }

          #entry:selected #text {
            color: @${accent};
          }

          #entry:drop(active) {
            background-color: @${accent}!important;
          }
        '';
    };
  };

  xdg = {
    configFile = {
      "wofi/menu" = {
        text = ''
          POSITION=3
          YOFF=15
          XOFF=-30

          FIELDS=SSID,IN-USE,BARS,SECURITY
        '';
      };

      "wofi/executable_wifi" = {
        text = ''
          POSITION=3
          YOFF=65
          XOFF=-40

          FIELDS=SSID,SECURITY,BARS
        '';
      };
    };
  };
}
