{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:

let
  json = [
    ./editor/autoclose.json
    ./editor/completion.json
    ./editor/cursor.json
    ./editor/cursor.json
    ./editor/font.json
    ./editor/hints.json
    ./editor/hover.json
    ./editor/line.json
    ./editor/save.json
    ./editor/whitespace.json

    ./extensions/biome.json
    ./extensions/catppuccin-icons.json
    ./extensions/csv.json
    ./extensions/deno.json
    ./extensions/docker-compose.json
    ./extensions/dockerfile.json
    ./extensions/git-firefly.json
    ./extensions/html.json
    ./extensions/http.json
    ./extensions/ini.json
    ./extensions/java.json
    ./extensions/latex.json
    ./extensions/log.json
    ./extensions/make.json
    ./extensions/mermaid.json
    ./extensions/nginx.json
    ./extensions/nix.json
    ./extensions/prisma.json
    ./extensions/python.json
    ./extensions/rainbow-csv.json
    ./extensions/ruby.json
    ./extensions/sql.json
    ./extensions/terraform.json
    ./extensions/toml.json
    ./extensions/xml.json

    ./languages/c.json
    ./languages/nix.json
    ./languages/typescript.json

    ./mode/vim.json

    ./ui/layout/centered.json

    ./ui/calls.json
    ./ui/dock.json
    ./ui/font.json
    ./ui/journal.json
    ./ui/preview.json
    ./ui/projects.json
    ./ui/quit.json
    ./ui/scrollbar.json
    ./ui/tabs.json
    ./ui/toolbar.json

    ./direnv.json
    ./formatter.json
    ./git.json
    ./telemetry.json
    ./terminal.json
    ./theme.json
    ./update.json
  ];
in
{
  home = {
    activation = {
      zedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm $HOME/.config/zed/settings.json
        rm $HOME/.config/zed/settings.json.${osConfig.home-manager.backupFileExtension}
        run echo -e "${
          (builtins.replaceStrings [ ''"'' ] [ ''\"'' ]) (
            (lib.lists.foldr (a: b: "${a}${b}") "") (builtins.map builtins.readFile json)
          )
        }" | ${pkgs.jq}/bin/jq -s 'reduce .[] as $item ({}; . * $item)' > $HOME/.config/zed/settings.json
      '';
    };
  };

  programs = {
    zed-editor = {
      enable = true;
      package = inputs.nixpkgs-small.legacyPackages."${pkgs.system}".zed-editor;

      extraPackages = with pkgs; [
        nixd
        clang-tools
        gnome-keyring
      ];
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

  xdg = {
    configFile = {
      "zed/themes/catppuccin-pink.json" = {
        source = ./themes/catppuccin-pink.json;
      };
    };
  };
}
