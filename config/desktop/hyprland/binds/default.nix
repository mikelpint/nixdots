{
  imports = [
    ./keyboard
    ./mouse
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
