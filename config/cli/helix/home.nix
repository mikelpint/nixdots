{ inputs, pkgs, ... }:

{
  imports = [ ./langs ];

  programs = {
    helix = {
      enable = true;

      package = inputs.helix.packages.${pkgs.system}.default.overrideAttrs
        (old: {
          makeWrapperArgs = with pkgs;
            old.makeWrapperArgs or [ ] ++ [
              "--suffix"
              "PATH"
              ":"
              (lib.makeBinPath [
                clang-tools
                marksman
                nil
                nodePackages.bash-language-server
                #nodePackages.vscode-langservers-extracted
                shellcheck
              ])
            ];
        });

      defaultEditor = true;

      settings = {
        editor = {
          color-modes = true;
          true-color = true;

          cursorline = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides = {
            render = true;
            character = "⸽";
            skip-levels = 1;
          };

          lsp = { display-inlay-hints = true; };

          statusline = { center = [ "position-percentage" ]; };

          whitespace = {
            render = {
              space = "all";
              tab = "all";
              newline = "none";
            };

            characters = {
              space = "·";
              newline = "↴";
              nbsp = "⍽";
              tab = "⇥";
              tabpad = "·";
            };
          };
        };

        keys = { normal = { space = { u = { f = ":format"; }; }; }; };
      };
    };
  };

  catppuccin = {
    helix = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
