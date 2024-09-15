{ pkgs, lib, ... }:

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

    ./languages/c.json
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
    packages = with pkgs; [ zed-editor ];

    activation = {
      zedSettings =
        lib.hm.dag.entryAfter
          [
            "writeBoundary"
          ]
          ''
            run echo -e "${
              (builtins.replaceStrings
                [
                  "\""
                ]
                [
                  "\\\""
                ]
              )
                ((lib.lists.foldr (a: b: "${a}${b}") "") (builtins.map builtins.readFile json))
            }" | ${pkgs.jq}/bin/jq -s add > $HOME/.config/zed/settings.json
          '';
    };
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
      "zed/themes/catppuccin-pink.json" = {
        source = ./themes/catppuccin-pink.json;
      };
    };
  };
}
