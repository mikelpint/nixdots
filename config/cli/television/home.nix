{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  programs = {
    television = {
      enable = false;
      package = inputs.television.packages.${pkgs.system}.television or pkgs.television;

      enableBashIntegration = true;
      enableZshIntegration = config.programs.zsh.enable or false;

      settings = {
        tick_rate = 50;

        default_channel = "files";

        history_size = 200;
        global_history = false;

        ui = {
          use_nerd_font_icons = false;

          ui_scale = 100;

          input_bar_position = "top";

          orientation = "landscape";

          theme = "default";

          preview_size = 50;

          features = {
            preview_panel = {
              enabled = true;
              visible = true;
            };

            help_panel = {
              enabled = true;
              visible = false;
            };

            status_bar = {
              enabled = true;
              visible = true;
            };

            remote_control = {
              enabled = true;
              visible = false;
            };
          };

          status_bar = {
            separator_open = "";
            separator_close = "";
          };

          preview_panel = {
            size = 50;

            scrollbar = true;
          };

          remote_control = {
            show_channel_descriptions = true;

            sort_alphabetically = true;
          };
        };

        keybindings = {
          quit = [
            "esc"
            "ctrl-c"
          ];

          select_next_entry = [
            "down"
            "ctrl-n"
            "ctrl-j"
          ];
          select_prev_entry = [
            "up"
            "ctrl-p"
            "ctrl-k"
          ];
          select_next_page = [ "pagedown" ];
          select_prev_page = [ "pageup" ];

          select_prev_history = [ "ctrl-up" ];
          select_next_history = [ "ctrl-down" ];

          toggle_selection_down = [ "tab" ];
          toggle_selection_up = [ "backtab" ];
          confirm_selection = [ "enter" ];

          scroll_preview_half_page_down = [ "mousescrolldown" ];
          scroll_preview_half_page_up = [ "mousescrollup" ];

          copy_entry_to_clipboard = [ "ctrl-y" ];

          reload_source = [ "ctrl-y" ];
          cycle_sources = [ "ctrl-s" ];

          toggle_remote_control = [ "ctrl-t" ];
          toggle_preview = [ "ctrl-o" ];
          toggle_help = [ "ctrl-h" ];
          toggle_status_bar = [ "f12" ];
        };

        shell_integration = {
          fallback_channel = "files";

          channel_triggers = {
            alias = [
              "alias"
              "unalias"
            ];
            env = [
              "export"
              "unset"
            ];
            dirs = [
              "cd"
              "ls"
              "rmdir"
            ];
            files = [
              "cat"
              "less"
              "head"
              "tail"
              "vim"
              "nano"
              "bat"
              "cp"
              "mv"
              "rm"
              "touch"
              "chmod"
              "chown"
              "ln"
              "tar"
              "zip"
              "unzip"
              "gzip"
              "gunzip"
              "xz"
            ];
            git-diff = [
              "git add"
              "git restore"
            ];
            git-branch = [
              "git checkout"
              "git branch"
              "git merge"
              "git rebase"
              "git pull"
              "git push"
            ];
            git-log = [
              "git log"
              "git show"
            ];
            docker-images = [ "docker run" ];
            git-repos = [
              "nvim"
              "code"
              "hx"
              "git clone"
            ];
          };

          keybindings = {
            smart_autocomplete = [ "ctrl-t" ];

            command_history = [ "ctrl-r" ];
          };
        };

        previewers = {
          file = {
            theme =
              lib.optional (config.catppuccin.enable or false)
                "Catppuccin ${(lib.strings.toUpper (lib.strings.substring 0 1 config.catppuccin.flavor))}${
                  lib.strings.substring 1 (-1) config.catppuccin.flavor
                }";
          };
        };
      }
      // (lib.optionalAttrs (config.catppuccin.enable or false) (
        let
          inherit (config.catppuccin) flavor accent;
        in
        {
          ui = {
            theme = "catppuccin-${flavor}-${accent}.toml";
          };

          previewers = {
            file = {
              theme = "Catppuccin ${(lib.strings.toUpper (lib.strings.substring 0 1 flavor))}${
                lib.strings.substring 1 (-1) flavor
              }";
            };
          };
        }
      ));
    };
  };

  xdg =
    lib.mkIf ((config.programs.television.enable or false) && (config.catppuccin.enable or false))
      (
        let
          inherit (config.catppuccin) flavor accent;
        in
        {
          configFile = {
            "television/themes/catppuccin-${flavor}-${accent}.toml" = {
              source = "${
                pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "television";
                  rev = "d021b8c48bac87a30a408ec8cc154373b27eac0b";
                  sha256 = "rfhj2QyQBZt53W2RgTJmXxe8pEgnS5ziJu+lSB8JikE=";
                }
              }/themes/catppuccin-${flavor}-${accent}.toml";
            };
          };
        }
      );
}
