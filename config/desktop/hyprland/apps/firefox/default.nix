{ user, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          envd =
            [ "MOZ_ENABLE_WAYLAND,1" "MOZ_GTK_TITLEBAR_DECORATION,client" ];
        };
      };
    };
  };

  programs = {
    firefox = {
      profiles = {
        ${user} = {
          settings = { browser = { tabs = { inTitlebar = 1; }; }; };
        };
      };
    };
  };
}
