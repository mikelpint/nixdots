{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bind = [
            "$mainMod CTRL SHIFT, R, exec, hyprctl reload"
            "$mainMod CTRL SHIFT, Q, exec, hyprctl kill"

            "$mainMod, Q, killactive,"
            "$mainMod, space, togglefloating,"
            "$mainMod, g, togglegroup"

            "$mainMod, left, movefocus, l"
            "$mainMod, down, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, right, movefocus, d"

            "$mainMod SHIFT, tab, workspace, +1"
            "$mainMod, tab, workspace, +1"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            "$mainMod SHIFT, left, movewindow, l"
            "$mainMod SHIFT, right, movewindow, r"
            "$mainMod SHIFT, up, movewindow, u"
            "$mainMod SHIFT, down, movewindow, d"

            "$mainMod CTRL, 1, movetoworkspace, 1"
            "$mainMod CTRL, 2, movetoworkspace, 2"
            "$mainMod CTRL, 3, movetoworkspace, 3"
            "$mainMod CTRL, 4, movetoworkspace, 4"
            "$mainMod CTRL, 5, movetoworkspace, 5"
            "$mainMod CTRL, 6, movetoworkspace, 6"
            "$mainMod CTRL, 7, movetoworkspace, 7"
            "$mainMod CTRL, 8, movetoworkspace, 8"
            "$mainMod CTRL, 9, movetoworkspace, 9"
            "$mainMod CTRL, 0, movetoworkspace, 10"
            "$mainMod CTRL, left, movetoworkspace, -1"
            "$mainMod CTRL, right, movetoworkspace, +1"
            "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
            "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
            "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
            "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
            "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
            "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
            "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
            "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          ];
        };
      };
    };
  };
}
