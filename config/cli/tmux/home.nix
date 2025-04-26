{ pkgs, ... }:
{
  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      terminal = "xterm-256color";
      escapeTime = 0;
      keyMode = "vi";
      prefix = "C-b";
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'macchiato'

            set -g @catppuccin_window_status_enable "yes"
            set -g @catppuccin_window_status_icon_enable "yes"

            set -g @catppuccin_icon_window_zoom " "
            set -g @catppuccin_icon_window_last "null"
            set -g @catppuccin_icon_window_current "null"
            set -g @catppuccin_icon_window_mark "null"
            set -g @catppuccin_icon_window_silent "null"
            set -g @catppuccin_icon_window_activity "null"
            set -g @catppuccin_icon_window_bell "null"

            set -g @catppuccin_window_middle_separator "null"

            set -g @catppuccin_window_default_background "#cad3f5"
            set -g @catppuccin_window_default_color "#24273a"
            set -g @catppuccin_window_default_fill "all"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_background "#363a4f"
            set -g @catppuccin_window_current_color "#c6a0f6"
            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory session"
            set -g @catppuccin_maximized_text "null"
            set -g @catppuccin_status_left_separator "█"
            set -g @catppuccin_status_right_separator "█"
            set -g @catppuccin_directory_color "#8aadf4"

            set -g pane-active-border-style fg="#c6a0f6"
          '';
        }
        {
          plugin = rose-pine;
          extraConfig = builtins.readFile ./rose-pine.conf;
        }
        yank
        sensible
        tmux-fzf
        vim-tmux-navigator
      ];
      extraConfig = ''
        if-shell 'test "$(uname)" = "Darwin"' 'set-option -g default-command "reattach-to-user-namespace -l zsh"'
        set -g default-shell '${pkgs.zsh}/bin/zsh'

        set -g default-terminal "screen-256color"

        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        bind -n M-H previous-window
        bind -n M-L next-window

        bind | split-window -h -c "#{pane_current_path}"
        bind _ split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        bind-key < resize-pane -L
        bind-key - resize-pane -D
        bind-key + resize-pane -U
        bind-key > resize-pane -R

        set -g mouse on

        set-option -g allow-rename off

        bind Escape kill-server

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        set -g detach-on-destroy off

        set -g renumber-windows on

        set -g status-position top

        bind-key -r f run-shell "tmux neww tmux-sessionizer-script"
      '';
    };
  };

  home = {
    packages = with pkgs; [
      tmux-sessionizer
      (writeShellScriptBin "tmux-sessionizer-script" ''
            if [[ $# -eq 1 ]]; then
            selected=$1
        else
            selected=$(find ~/ ~/projects ~/tests -mindepth 1 -maxdepth 1 -type d | fzf)
        fi

        if [[ -z $selected ]]; then
            exit 0
        fi

        selected_name=$(basename "$selected" | tr . _)
        tmux_running=$(pgrep tmux)

        if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
            tmux new-session -s $selected_name -c $selected
            exit 0
        fi

        if ! tmux has-session -t=$selected_name 2> /dev/null; then
            tmux new-session -ds $selected_name -c $selected
        fi

        if [[ -z $TMUX ]]; then
            tmux attach -t $selected_name
        else
            tmux switch-client -t $selected_name
        fi
      '')
    ];
  };
}
