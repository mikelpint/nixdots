{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ zed-editor ];
  };

  programs = {
    mangohud = {
      settingsPerApplication = {
        zed = {
          no_display = true;
        };
      };
    };
  };

  xdg = {
    configFile = {
      "zed/settings.json" = {
        text = ''
            {
              "telemetry": {
                  "diagnostics": false,
                  "metrics": false
              },

              "autosave": "off",

              "auto_update": false,

              "buffer_font_family": "JetBrainsMono Nerd Font",
              "buffer_font_weight": 400,
              "buffer_font_features": {},
              "buffer_font_size": 18,

              "buffer_line_height": {
                  "custom": 1.5
              },

              "ui_font_size": 18,
              "ui_font_family": "JetBrainsMono Nerd Font",

              "centered_layout": {
                  "left_padding": 0,
                  "right_padding": 0.2
              },

              "confirm_quit": false,

              "load_direnv": "shell_hook",

              "show_completions_on_input": true,
              "show_completion_documentation": true,
              "completion_documentation_secondary_query_debounce": 300,
              "show_inline_completions": true,
              "inline_completions": {
                  "disabled_globs": [
                      ".env"
                  ]
              },

              "current_line_highlight": "gutter",

              "cursor_blink": true,

              "default_dock_anchor": "bottom",
              "scrollbar": {
                  "show": "never",
                  "cursors": true,
                  "git_diff": true,
                  "search_results": true,
                  "selected_symbol": true,
                  "diagnostics": true
              },
              "tab_bar": {
                  "show": false,
                  "show_nav_history_buttons": true
              },
              "tabs": {
                  "close_position": "right",
                  "file_icons": true,
                  "git_status": true
              },
              "toolbar": {
                  "breadcrumbs": true,
                  "quick_actions": true,
                  "selections_menu": true
              },
              "enable_language_server": true,
              "lsp": {
                "clangd": {
                  "binary": {
                    "path": "${pkgs.clang-tools}/bin/clangd",
                    "arguments": ["--background-index", "--compile-commands-dir=build"]
                  }
                }
              },
              "languages": {
                  "C": {
                    "enable_language_server": true,
                    "language_servers": [ "clangd" ]
                  }
              },
              "ensure_final_newline_on_save": true,
              "remove_trailing_whitespace_on_save": true,
              "format_on_save": "on",
              "formatter": "language_server",
              "git": {
                  "git_gutter": "tracked_files",
                  "inline_blame": {
                      "enabled": true
                  }
              },
              "show_whitespaces": "all",
              "indent_guides": {
                  "enabled": true,
                  "line_width": 1,
                  "active_line_width": 1,
                  "coloring": "fixed",
                  "background_coloring": "disabled"
              },
              "hard_tabs": false,
              "tab_size": 4,
              "preferred_line_length": 120,
              "soft_wrap": "prefer_line",
              "show_wrap_guides": true,
              "wrap_guides": [
                  120
              ],
              "hover_popover_enabled": true,
              "inlay_hints": {
                  "enabled": true,
                  "show_type_hints": true,
                  "show_parameter_hints": true,
                  "show_other_hints": true,
                  "edit_debounce_ms": 700,
                  "scroll_debounce_ms": 50
              },
              "preview_tabs": {
                  "enabled": true,
                  "enable_preview_from_file_finder": false,
                  "enable_preview_from_code_navigation": false
              },
              "journal": {
                  "path": "~",
                  "hour_format": "hour12"
              },
              "use_autoclose": true,
              "always_treat_brackets_as_autoclosed": false,
              "projects_online_by_default": false,
              "show_call_status_icon": true,
              "calls": {
                  "mute_on_join": false,
                  "share_on_join": false
              },
              "project_panel": {
                  "button": true,
                  "dock": "left",
                  "git_status": true,
                  "default_width": 240,
                  "auto_reveal_entries": true,
                  "auto_fold_dirs": false,
                  "file_icons": true,
                  "folder_icons": true,
                  "indent_size": 20,
                  "scrollbar": {
                      "show": "always"
                  }
              },

              "terminal": {
                  "alternate_scroll": "off",
                  "blinking": "terminal_controlled",
                  "copy_on_select": false,
                  "env": {},
                  "font_family": null,
                  "font_features": null,
                  "font_size": null,
                  "option_as_meta": false,
                  "button": false,
                  "shell": {},
                  "toolbar": {
                      "title": true
                  },
                  "working_directory": "current_project_directory"
              },

              "theme": {
                  "mode": "system",
                  "light": "Catppuccin Macchiato (pink)",
                  "dark": "Catppuccin Macchiato (pink)"
              },

              "vim": {
                  "use_multiline_find": true,
                  "use_smartcase_find": true,
                  "use_system_clipboard": "always"
              },
              "vim_mode": false
          }
        '';
      };

      "zed/themes/catppuccin-pink.json" = {
        source = ./catppuccin-pink.json;
      };
    };
  };
}
