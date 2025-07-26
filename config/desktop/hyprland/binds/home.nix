{
  imports = [
    ./keyboard/home.nix
    ./media/home.nix
    ./mouse/home.nix
  ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          "$mainMod" = "SUPER";
          "$altMod" = "ALT";
        };
      };
    };
  };
}
