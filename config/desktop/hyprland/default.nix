{ pkgs, inputs, ... }:
let
  hyprlandFlake = inputs.hyprland.packages.${pkgs.system}.hyprland;
  fontsize = "12";
  oxocarbon_pink = "ff7eb6";
  oxocarbon_border = "393939";
  oxocarbon_background = "161616";
  background = "rgba(11111B00)";
  tokyonight_border = "rgba(7aa2f7ee) rgba(87aaf8ee) 45deg";
  tokyonight_background = "rgba(32344aaa)";
  catppuccin_border = "rgba(b4befeee)";
  opacity = "0.95";
  cursor = "macOS-BigSur";
in {
  home = {
    packages = with pkgs; [
      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')
      (writeShellScriptBin "autostart" ''
        config=$HOME/.config/hypr
        scripts=$config/scripts

        pkill waybar
        $scripts/launch_waybar &
        $scripts/tools/dynamic &

        pkill dunst
        dunst &

        hyprctl setcursor "macOS-BigSur" 32

        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;

        xwayland = { enable = true; };

        settings = {
          "$mainMod" = "SUPER";
          monitor = [ ",highrr,auto,auto" ];

          xwayland = { force_zero_scaling = true; };

          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            follow_mouse = 1;
            repeat_delay = 140;
            repeat_rate = 30;
            numlock_by_default = 1;
            accel_profile = "flat";
            sensitivity = 0;
            force_no_accel = 1;
            touchpad = { natural_scroll = 1; };
          };

          general = {
            gaps_in = 1;
            gaps_out = 2;
            border_size = 3;

            col = {
              activity_border = "${catppuccin_border}";
              inactive_border = "${tokyonight_background}";
            };

            layout = "dwindle";
            apply_sens_to_raw = 1;
          };

          decoration = {
            rounding = 12;
            shadow_ignore_window = true;
            drop_shadow = false;
            shadow_range = 20;
            shadow_render_power = 3;

            col = {
              shadow = "rgb(${oxocarbon_background})";
              shadow_inactive = "${background}";
            };

            blur = {
              enabled = false;
              size = 5;
              passes = 3;
              new_optimizations = true;
              ignore_opacity = true;
              noise = 1.17e-2;
              contrast = 1.5;
              brightness = 1;
              xray = true;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "pace,0.46, 1, 0.29, 0.99"
              "overshot,0.13,0.99,0.29,1.1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
            ];
            animation = [
              "windowsIn,1,6,md3_decel,slide"
              "windowsOut,1,6,md3_decel,slide"
              "windowsMove,1,6,md3_decel,slide"
              "fade,1,10,md3_decel"
              "workspaces,1,9,md3_decel,slide"
              "workspaces, 1, 6, default"
              "specialWorkspace,1,8,md3_decel,slide"
              "border,1,10,md3_decel"
            ];
          };

          misc = {
            vfr = true;
            vrr = false;
          };

          dwindle = {
            pseudotile = true; # enable pseudotiling on dwindle
            force_split = 0;
            preserve_split = true;
            default_split_ratio = 1.0;
            no_gaps_when_only = false;
            special_scale_factor = 0.8;
            split_width_multiplier = 1.0;
            use_active_for_splits = true;
          };

          master = {
            mfact = 0.5;
            orientation = "right";
            special_scale_factor = 0.8;
            new_is_master = true;
            no_gaps_when_only = false;
          };

          gestures = { workspace_swipe = false; };

          debug = { damage_tracking = 2; };

          exec-once = [ "autostart" "easyeffects --gapplication-service" ];
        };
      };
    };
  };

  xdg = {
    configFile = {
      "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
      "hypr/store/prev.txt".source = ./store/prev.txt;
      "hypr/store/latest_notif".source = ./store/latest_notif;

      "hypr/scripts/launch_waybar".source = ../extras/waybar/launch;

      "hypr/scripts/dynamic".source = ./scripts/dynamic;
      "hypr/scripts/expand".source = ./scripts/expand;
      "hypr/scripts/notif".source = ./scripts/notif;
      "hypr/scripts/start_dyn".source = ./scripts/start_dyn;
    };
  };
}
