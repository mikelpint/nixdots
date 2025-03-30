{ pkgs, ... }: {
  xdg = {
    configFile = {
      "hypr/macchiato.conf" = {
        text = ''
          $rosewater = rgb(f4dbd6)
          $rosewaterAlpha = f4dbd6

          $flamingo = rgb(f0c6c6)
          $flamingoAlpha = f0c6c6

          $pink = rgb(f5bde6)
          $pinkAlpha = f5bde6

          $mauve = rgb(c6a0f6)
          $mauveAlpha = c6a0f6

          $red = rgb(ed8796)
          $redAlpha = ed8796

          $maroon = rgb(ee99a0)
          $maroonAlpha = ee99a0

          $peach = rgb(f5a97f)
          $peachAlpha = f5a97f

          $yellow = rgb(eed49f)
          $yellowAlpha = eed49f

          $green = rgb(a6da95)
          $greenAlpha = a6da95

          $teal = rgb(8bd5ca)
          $tealAlpha = 8bd5ca

          $sky = rgb(91d7e3)
          $skyAlpha = 91d7e3

          $sapphire = rgb(7dc4e4)
          $sapphireAlpha = 7dc4e4

          $blue = rgb(8aadf4)
          $blueAlpha = 8aadf4

          $lavender = rgb(b7bdf8)
          $lavenderAlpha = b7bdf8

          $text = rgb(cad3f5)
          $textAlpha = cad3f5

          $subtext1 = rgb(b8c0e0)
          $subtext1Alpha = b8c0e0

          $subtext0 = rgb(a5adcb)
          $subtext0Alpha = a5adcb

          $overlay2 = rgb(939ab7)
          $overlay2Alpha = 939ab7

          $overlay1 = rgb(8087a2)
          $overlay1Alpha = 8087a2

          $overlay0 = rgb(6e738d)
          $overlay0Alpha = 6e738d

          $surface2 = rgb(5b6078)
          $surface2Alpha = 5b6078

          $surface1 = rgb(494d64)
          $surface1Alpha = 494d64

          $surface0 = rgb(363a4f)
          $surface0Alpha = 363a4f

          $base = rgb(24273a)
          $baseAlpha = 24273a

          $mantle = rgb(1e2030)
          $mantleAlpha = 1e2030

          $crust = rgb(181926)
          $crustAlpha = 181926
        '';
      };
    };
  };

  home = {
    packages = with pkgs; [
      glib
      dconf-editor
      gsettings-desktop-schemas

      (writeShellScriptBin "hyprsetup_theme" ''
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-schema 'prefer-dark'
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_theme" ];

          envd = with pkgs;
            [
              "GSETTINGS_SCHEMA_DIR,${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas"
            ];
        };
      };
    };
  };
}
