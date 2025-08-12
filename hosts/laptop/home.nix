{ self, ... }:
{
  imports = [
    ../../presets/desktop/home.nix
    ../../presets/dev/home.nix
    ../../presets/music/home.nix
    ../../presets/rice/home.nix
    ../../presets/social/home.nix
    ../../presets/video/home.nix

    ../../config/desktop/extra/waybar/presets/laptop/home.nix

    ../../config/hardware/laptop/home.nix
  ];

  services = {
    hyprpaper = {
      settings =
        let
          preload = "${self}/assets/wallpapers/dithered/lighthouse.png";
        in
        {
          inherit preload;
          wallpaper = ",${preload}";
        };
    };
  };
}
