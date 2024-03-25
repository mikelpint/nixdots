{
  programs = {
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local wezterm = require "wezterm"
        local act = wezterm.action
        local xcursor_size = 32
        local xcursor_theme = "macOS-BigSur"
        return {
          adjust_window_size_when_changing_font_size = false,
          animation_fps = 0,
          check_for_updates = false,
          cell_width = 0.88,
          cursor_blink_ease_in = 'EaseIn',
          cursor_blink_ease_out = 'EaseOut',
          color_scheme = "Catppuccin Macchiato",
          default_cursor_style = "SteadyBlock",
          enable_scroll_bar = false,
          enable_tab_bar = false,
          enable_wayland = false,
          font_size = 13,
          font = wezterm.font('MonoLisa', { weight = 'Medium', italic = true }),
          font = wezterm.font_with_fallback {
          { family = 'MonoLisa-italic', weight = 'Medium', italic = true },
          'Noto Color Emoji',
          },
          freetype_load_flags = 'NO_HINTING',
          freetype_load_target = 'Normal',
          front_end = "WebGpu",
          hide_tab_bar_if_only_one_tab = true,
          hide_mouse_cursor_when_typing = false,
          line_height = 1.0,
          scrollback_lines = 8000,
          term = "xterm-256color",
          use_fancy_tab_bar = false,
          warn_about_missing_glyphs = false,
          window_decorations = "RESIZE",
          window_background_opacity = 0.98,
          window_padding = {
            left = 10,
            right = 10,
            top = 10,
            bottom = 10,
          },
          xcursor_theme = xcursor_theme,
          xcursor_size = xcursor_size,
          keys = {
            { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
            { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
          },
          mouse_bindings = {
          { event = { Up = { streak = 1, button = 'Left' } }, mods = 'NONE', action = act.CompleteSelection 'Clipboard', },},
        }
      '';
    };
  };
}
