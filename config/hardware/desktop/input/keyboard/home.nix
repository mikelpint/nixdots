{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            kb_layout = "us, es";
            kb_options = "";
          };

          bindlt = [
            "$mainMod, space, exec, hyprctl switchxkblayout keychron-keychron-q2 next"
          ];
        };
      };
    };
  };
}
