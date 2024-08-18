{
  imports = [ ./gaps ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          general = {
            layout = "dwindle";
          };

          master = {
            mfact = 0.5;
            orientation = "right";
            special_scale_factor = 0.8;
            new_status = "master";
            no_gaps_when_only = false;
          };

          dwindle = {
            pseudotile = true;
            force_split = 0;
            preserve_split = true;
            default_split_ratio = 1.0;
            no_gaps_when_only = false;
            special_scale_factor = 0.8;
            split_width_multiplier = 1.0;
            use_active_for_splits = true;
          };
        };
      };
    };
  };
}
