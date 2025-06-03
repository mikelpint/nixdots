{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  programs = {
    zed-editor = {
      enable = true;
      package = inputs.nixpkgs-small.legacyPackages."${pkgs.system}".zed-editor;

      extraPackages = with pkgs; [
        nixd
        clang-tools
        gnome-keyring
      ];

      extensions = [
        "biome"
        "catppuccin-icons"
        "csv"
        "deno"
        "docker-compose"
        "dockerfile"
        "git-firefly"
        "html"
        "http"
        "ini"
        "java"
        "latex"
        "log"
        "make"
        "mermaid"
        "nginx"
        "nix"
        "prisma"
        "python"
        "rainbow-csv"
        "ruby"
        "sql"
        "terraform"
        "toml"
        "xml"
      ];

      userSettings = {
        use_autoclose = true;
        always_treat_brackets_as_autoclosed = false;
        show_completions_on_input = true;
        show_completion_documentation = true;
        completion_documentation_secondary_query_debounce = 300;
        show_edit_predictions = true;
        inline_predictions = {
          disabled_globs = [
            ".env"
          ];
        };

        cursor_blink = true;

        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_weight = 400;
        buffer_font_features = { };
        buffer_font_size = 18;
        buffer_line_height = {
          custom = 1.5;
        };

        inlay_hints = {
          enabled = false;
          show_type_hints = true;
          show_parameter_hints = true;
          show_other_hints = true;
          edit_debounce_ms = 700;
          scroll_debounce_ms = 50;
        };
        hover_popover_enabled = true;

        current_line_highlight = "gutter";
        preferred_line_length = 120;
        soft_wrap = "prefer_line";
        show_wrap_guides = true;
        wrap_guides = [
          120
        ];

        autosave = "off";
        ensure_final_newline_on_save = true;
        remove_trailing_whitespace_on_save = true;

        show_whitespaces = "all";
        indent_guides = {
          enabled = true;
          line_width = 1;
          active_line_width = 1;
          coloring = "fixed";
          background_coloring = "disabled";
        };
        hard_tabs = false;
        tab_size = 4;

        auto_install_extensions = {
          biome = true;
          catppuccin-icons = true;
          csv = true;
          deno = true;
          docker-compose = true;
          dockerfile = true;
          git-firefly = true;
          html = true;
          http = true;
          ini = true;
          java = true;
          latex = true;
          log = true;
          make = true;
          mermaid = true;
          nginx = true;
          nix = true;
          prisma = true;
          python = true;
          rainbow-csv = true;
          ruby = true;
          sql = true;
          terraform = true;
          toml = true;
          xml = true;
        };

        enable_language_server = true;

        lsp = {
          clangd = {
            binary = {
              path = "${lib.getBin pkgs.clang-tools}/bin/clangd";
              arguments = [
                "--background-index"
                "--compile-commands-dir=build"
              ];
            };
          };

          nixd = {
            binary = {
              path = "${lib.getBin pkgs.nixd}/bin/nixd";
            };

            settings = {
              autoArchive = true;
            };
          };

          tailwindcss-language-server = {
            settings = {
              classAttributes = [
                "class"
                "className"
                "ngClass"
                "styles"
              ];
            };
          };

          typescript-language-server = {
            preferences = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
          };
        };

        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];

            formatter = {
              external = {
                command = "nix";
                arguments = [
                  "fmt"
                  "--quiet"
                ];
              };
            };
          };

          TypeScript = {
            language_servers = [
              "biome"
              "!eslint"
              "!prettier"
              "..."
            ];

            inlay_hints = {
              enabled = true;
              show_parameter_hints = false;
              show_other_hints = true;
              show_type_hints = true;
            };
          };
        };

        vim_mode = false;
        vim = {
          use_multiline_find = true;
          use_smartcase_find = true;
          use_system_clipboard = "always";
        };

        show_call_status_icon = true;
        calls = {
          mute_on_join = false;
          share_on_join = false;
        };

        centered_layout = {
          left_padding = 0;
          right_padding = 0.2;
        };
        default_dock_anchor = "bottom";
        ui_font_size = 18;
        ui_font_family = "JetBrainsMono Nerd Font";

        journal = {
          path = "~";
          hour_format = "hour24";
        };

        preview_tabs = {
          enabled = true;
          enable_preview_from_file_finder = false;
          enable_preview_from_code_navigation = false;
        };

        projects_online_by_default = false;
        project_panel = {
          button = true;
          dock = "left";
          git_status = true;
          default_width = 240;
          auto_reveal_entries = true;
          auto_fold_dirs = false;
          file_icons = true;
          folder_icons = true;
          indent_size = 20;
          scrollbar = {
            show = "always";
          };
        };

        confirm_quit = false;

        scrollbar = {
          show = "never";
          cursors = true;
          git_diff = true;
          search_results = true;
          selected_symbol = true;
          diagnostics = "all";
        };

        tab_bar = {
          show = false;
          show_nav_history_buttons = true;
        };
        tabs = {
          close_position = "right";
          file_icons = true;
          git_status = true;
        };

        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };

        load_direnv = "shell_hook";

        format_on_save = "on";
        formatter = "language_server";

        git = {
          git_gutter = "tracked_files";
          inline_blame = {
            enabled = true;
          };
        };

        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        terminal = {
          working_directory = "current_project_directory";
          alternate_scroll = "off";
          blinking = "terminal_controlled";
          copy_on_select = false;
          font_family = "JetBrainsMono Nerd Font";
          font_features = null;
          font_size = null;
          option_as_meta = false;
          button = false;
          toolbar = {
            title = true;
          };
        };

        icon_theme = "Catppuccin Macchiato";
        theme = {
          mode = "system";
          light = "Catppuccin Macchiato (pink)";
          dark = "Catppuccin Macchiato (pink)";
        };

        auto_update = false;
      };
    };

    mangohud = {
      settingsPerApplication = {
        zed = {
          no_display = true;
        };
        zeditor = {
          no_display = true;
        };
      };
    };
  };

  nixGL = lib.mkIf config.programs.zed-editor.enable {
    vulkan = {
      enable = true;
    };
  };

  xdg = {
    configFile = {
      "zed/themes/catppuccin-pink.json" = {
        source = ./themes/catppuccin-pink.json;
      };
    };
  };
}
