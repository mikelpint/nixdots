{
  pkgs,
  config,
  lib,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        prismlauncher-unwrapped = super.prismlauncher-unwrapped.overrideAttrs (
          _old: with pkgs; {
            additionalPrograms = [ ffmpeg ];
            jdks = [
              jdk8
              jdk23

              jetbrains.jdk
            ];
          }
        );
      })
    ];
  };

  home = {
    packages = with pkgs; [
      # minecraft
      prismlauncher-unwrapped
    ];
  };

  xdg = {
    dataFile =
      let
        inherit (config.catppuccin) enable flavor accent;
      in
      lib.mkIf enable (
        let
          theme = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "prismlauncher";
            rev = "0fdb45821012e4cd0872aa927b9d1f32e4eaaa51";
            sha256 = "/qUqF92e3kYkl59GUMMFRtRTzVgSp5tGPxnXLGeusys=";
          };
          dir = "themes/${(lib.strings.toUpper (lib.strings.substring 0 1 config.catppuccin.flavor))}${
            lib.strings.substring 1 (-1) config.catppuccin.flavor
          }";
        in
        {
          "PrismLauncher/themes/preview.png" = {
            source = "${theme}/${dir}/preview.png";
          };
          "PrismLauncher/themes/preview.png.license" = {
            source = "${theme}/${dir}/preview.png.license";
          };
          "PrismLauncher/themes/theme.json" = {
            text =
              let
                json = builtins.fromJSON (builtins.readFile "${theme}/${dir}/theme.json");
                palette = builtins.fromJSON (
                  builtins.readFile "${
                    pkgs.fetchFromGitHub {
                      owner = "catppuccin";
                      repo = "palette";
                      rev = "0df7db6fe201b437d91e7288fa22807bb0e44701";
                      sha256 = "R52Q1FVAclvBk7xNgj/Jl+GPCIbORNf6YbJ1nxH3Gzs=";
                    }
                  }/palette.json"
                );
              in
              builtins.toJSON (
                json
                // {
                  colors = {
                    Highlight = palette."${flavor}".colors."${accent}".hex;
                  };
                }
              );
          };
          "PrismLauncher/themes/theme.json.license" = {
            source = "${theme}/${dir}/theme.json.license";
          };
          "PrismLauncher/themes/themeStyle.css" = {
            source = "${theme}/${dir}/themeStyle.css";
          };
        }
      );
  };
}
