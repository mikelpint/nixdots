{ pkgs, inputs, config, ... }:
let
  cursorTheme =
    (import ../theme/cursor/default.nix { inherit pkgs; }).home.pointerCursor;
  opacity = "0.95";
  cursor = {
    name = cursorTheme.name;
    size = cursorTheme.size;
    package = cursorTheme.package;
  };
in {
  home = {
    packages = with pkgs; [
      hyprpicker
      hypridle
      hyprlock
      polkit_gnome
      cursor.package
      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')
      (writeShellScriptBin "autostart" ''
        config=$HOME/.config/hypr
        scripts=$config/scripts

        hyprctl dismissnotify

        pkill waybar
        $scripts/launch_waybar &

        pkill dunst
        dunst &

        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        package = (inputs.hyprland.packages."${pkgs.system}".hyprland.override {
          enableXWayland = true;
          legacyRenderer = true;
          withSystemd = true;
        });

        plugins = [
          inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
          inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        ];

        systemd = {
          enable = true;
          variables = [ "--all" ];
        };

        xwayland = { enable = true; };

        settings = {
          envd = [
            "WLR_DRM_DEVICES,$HOME/.config/hypr/card:$HOME/.config/hypr/otherCard"

            "HYPRLAND_NO_SD_NOTIFY,1"

            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            "NIXOS_OZONE_WL,1"

            "GDK_BACKEND,wayland,x11"
            "QT_QPA_PLATFORM,wayland;xcb"
            "CLUTTER_BACKEND,wayland"
            "SDL_VIDEODRIVER,wayland"

            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORMTHEME,qt6ct"

            "GDK_SCALE,2"

            "WLR_NO_HARDWARE_CURSORS,0"

            "HYPRCURSOR_THEME,${cursor.name}"
            "HYPRCURSOR_SIZE,${builtins.toString cursor.size}"

            "XCURSOR_THEME,${cursor.name}"
            "XCURSOR_SIZE,${builtins.toString cursor.size}"
          ];

          monitor = [ ",highrr,auto,auto" ];

          xwayland = { force_zero_scaling = true; };

          input = {
            kb_layout = "us,es";
            kb_variant = "";
            kb_model = "";
            kb_options = "grp:win_space_toggle";
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

            "col.active_border" =
              "rgb(8aadf4) rgb(24273A) rgb(24273A) rgb(8aadf4) 45deg";
            "col.inactive_border" =
              "rgb(24273A) rgb(24273A) rgb(24273A) rgb(24273A) 45deg";

            layout = "dwindle";
            apply_sens_to_raw = 1;
          };

          decoration = {
            rounding = 12;
            shadow_ignore_window = true;
            drop_shadow = false;
            shadow_range = 20;
            shadow_render_power = 3;

            "col.shadow" = "rgb(161616)";
            "col.shadow_inactive" = "rgba(11111B00)";

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
              "linear, 0.0, 0.0, 1.0, 1.0"
              "pace, 0.46, 1, 0.29, 0.99"
              "overshot, 0.13, 0.99, 0.29, 1.1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
            ];

            animation = [
              "windowsIn, 1, 6, md3_decel, slide"
              "windowsOut, 1, 6, md3_decel, slide"
              "windowsMove, 1, 6, md3_decel, slide"
              "fade, 1, 10, md3_decel"
              "workspaces, 1, 9, md3_decel, slide"
              "workspaces, 1, 6, default"
              "specialWorkspace, 1, 8, md3_decel, slide"
              "border, 1, 10, md3_decel"
              "borderangle, 1, 100, linear, loop"
            ];
          };

          cursor = {
            enable_hyprcursor = true;
            no_hardware_cursors = false;
            no_break_fs_vrr = false;
          };

          misc = {
            disable_autoreload = true;

            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;

            vfr = true;
            vrr = false;

            no_direct_scanout = false;
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

          master = {
            mfact = 0.5;
            orientation = "right";
            special_scale_factor = 0.8;
            new_status = "master";
            no_gaps_when_only = false;
          };

          gestures = { workspace_swipe = false; };

          debug = {
            disable_logs = false;
            damage_tracking = 2;
          };

          exec-once =
            [ "autostart" "hypridle" "easyeffects --gapplication-service" ];

          "$mainMod" = "SUPER";
          "$altMod" = "ALT";

          bind = [
            "$mainMod SHIFT, ESC, exit,"
            "$mainMod CTRL SHIFT, R, exec, hyprctl reload"
            "$mainMod CTRL SHIFT, Q, exec, hyprctl kill"
            "$mainMod, L, exec, pidof hyprlock || hyprlock"

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

            "$mainMod, RETURN, exec, wezterm start --always-new-process"
            ", Print, exec, screenshot"
            "$mainMod, Print, exec, screenshot-edit"
            "$mainMod SHIFT, C, exec, wallpaper"
            "$mainMod, space, exec, wofi --show drun -I -s ~/.config/wofi/style.css DP-3"
          ];

          bindm = [
            "$mainMod,mouse:272,movewindow"
            "$mainMod,mouse:273,resizewindow"
          ];

          windowrule = [ "tile,title:^(wezterm)$" "tile,^(Spotify)$" ];

          windowrulev2 = [
            "opacity ${opacity} ${opacity},class:^(thunar)$"
            "opacity ${opacity} ${opacity},class:^(discord)$"
            "opacity ${opacity} ${opacity},class:^(st-256color)$"
            "float,class:^(org.wezfurlong.wezterm)$"
            "tile,class:^(org.wezfurlong.wezterm)$"
            "float,class:^(pavucontrol)$"
            "float,class:^(file_progress)$"
            "float,class:^(confirm)$"
            "float,class:^(dialog)$"
            "float,class:^(download)$"
            "float,class:^(notification)$"
            "float,class:^(error)$"
            "float,class:^(confirmreset)$"
            "float,title:^(Open File)$"
            "float,title:^(branchdialog)$"
            "float,title:^(Confirm to replace files)$"
            "float,title:^(File Operation Progress)$"
            "float,title:^(mpv)$"
            "opacity 1.0 1.0,class:^(wofi)$"
          ];
        };
      };
    };
  };

  xdg = {
    configFile = {
      "hypr/scripts/launch_waybar".source = ../extras/waybar/launch;
      "hypr/macchiato.conf".text = ''
        $rosewater = rgb(f4dbd6)
        $rosewaterAlpha = f4dbd6

        $flamingo = rgb(f0c6c6)
        $flamingoAlpha = f0c6c6

        $pink = rgb(f5bde6)
        $pinkAlpha = f5bde6

        $mauve = rgb(c6a0f6)
        $mauveAlpha = c6a0f6

        $red = rgb(ed8796)
        $redAlpha = ed8796

        $maroon = rgb(ee99a0)
        $maroonAlpha = ee99a0

        $peach = rgb(f5a97f)
        $peachAlpha = f5a97f

        $yellow = rgb(eed49f)
        $yellowAlpha = eed49f

        $green = rgb(a6da95)
        $greenAlpha = a6da95

        $teal = rgb(8bd5ca)
        $tealAlpha = 8bd5ca

        $sky = rgb(91d7e3)
        $skyAlpha = 91d7e3

        $sapphire = rgb(7dc4e4)
        $sapphireAlpha = 7dc4e4

        $blue = rgb(8aadf4)
        $blueAlpha = 8aadf4

        $lavender = rgb(b7bdf8)
        $lavenderAlpha = b7bdf8

        $text = rgb(cad3f5)
        $textAlpha = cad3f5

        $subtext1 = rgb(b8c0e0)
        $subtext1Alpha = b8c0e0

        $subtext0 = rgb(a5adcb)
        $subtext0Alpha = a5adcb

        $overlay2 = rgb(939ab7)
        $overlay2Alpha = 939ab7

        $overlay1 = rgb(8087a2)
        $overlay1Alpha = 8087a2

        $overlay0 = rgb(6e738d)
        $overlay0Alpha = 6e738d

        $surface2 = rgb(5b6078)
        $surface2Alpha = 5b6078

        $surface1 = rgb(494d64)
        $surface1Alpha = 494d64

        $surface0 = rgb(363a4f)
        $surface0Alpha = 363a4f

        $base = rgb(24273a)
        $baseAlpha = 24273a

        $mantle = rgb(1e2030)
        $mantleAlpha = 1e2030

        $crust = rgb(181926)
        $crustAlpha = 181926
      '';
      "hypr/hypridle.conf".text = ''
        general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
        }

        listener {
          timeout = 150
          on-timeout = brightnessctl -s set 10
          on-resume = brightnessctl -r
        }

        listener { 
          timeout = 150
          on-timeout = brightnessctl -sd rgb:kbd_backlight set 0
          on-resume = brightnessctl -rd rgb:kbd_backlight
        }

        # listener {
        #   timeout = 300
        #   on-timeout = loginctl lock-session
        # }

        listener {
          timeout = 300
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
        }

        listener {
          timeout = 1800
          on-timeout = systemctl suspend
        }
      '';
      "hypr/hyprlock.conf".text = ''
        source = $HOME/.config/hypr/macchiato.conf

        $accent = $mauve
        $accentAlpha = $mauveAlpha
        $font = JetBrainsMono Nerd Font

        general {
            disable_loading_bar = true
            hide_cursor = true
        }

        background {
            monitor =
            path = ~/.config/background
            blur_passes = 0
            color = $base
        }

        label {
            monitor =
            text = cmd[update:30000] echo "$(date +"%R")"
            color = $text
            font_size = 90
            font_family = $font
            position = -30, 0
            halign = right
            valign = top
        }

        label {
            monitor = 
            text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
            color = $text
            font_size = 25
            font_family = $font
            position = -30, -150
            halign = right
            valign = top
        }

        image {
            monitor = 
            path = ~/.face
            size = 100
            border_color = $accent

            position = 0, 75
            halign = center
            valign = center
        }

        input-field {
            monitor =
            size = 300, 60
            outline_thickness = 4
            dots_size = 0.2
            dots_spacing = 0.2
            dots_center = true
            outer_color = $accent
            inner_color = $surface0
            font_color = $text
            fade_on_empty = false
            placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
            hide_input = false
            check_color = $accent
            fail_color = $red
            fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
            capslock_color = $yellow
            position = 0, -35
            halign = center
            valign = center
        }
      '';
    };
  };
}
