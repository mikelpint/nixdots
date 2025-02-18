{
  imports = [ ./keyboard ./media ./mouse ];

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
