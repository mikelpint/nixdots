{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = lib.mkIf (config.programs.gpg.enable or false) {
        key = "0xD78A0EF85709BB96!";
        signByDefault = true;
        format = "openpgp";
        signer = "${lib.getBin (config.programs.gpg.package or pkgs.gnupg)}/bin/gpg";
      };

      lfs = {
        enable = true;
      };

      delta = {
        enable = !(config.programs.git.difftastic.enable or false);
        package = pkgs.delta;

        options = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };

          features = lib.mkDefault "decorations";
          whitespace-error-style = "22 reverse";
        };
      };

      difftastic = {
        enable = true;
        enableAsDifftool = true;
        package = pkgs.difftastic;

        background = "dark";
        color = "auto";
        display = "side-by-side-show-both";
      };

      extraConfig = {
        hub = {
          username = "mikelpint";
        };

        init = {
          defaultBranch = "main";

          core = {
            editor = "hx";
          };

          pull = {
            rebase = false;
          };
        };

        core = {
          symlinks = false;
        };

        transfer = {
          fsckobjects = true;
        };

        fetch = {
          fsckobjects = true;
        };

        receive = {
          fsckobjects = true;
        };

        merge = {
          conflictstyle = "diff3";
        };
      };
    };

    gh = {
      enable = config.programs.git.enable or false;
      extensions = with pkgs; [
        gh-actions-cache
        gh-cal
        gh-eco
        gh-f
        gh-gei
        gh-i
        gh-markdown-preview
        gh-poi
        gh-s
      ];

      hosts = {
        "github.com" = {
          user = "mikelpint";
        };
      };

      settings = {
        aliases = { };
        editor = "";
        git_protocol = if (config.services.ssh.enable or false) then "ssh" else "https";
      };

      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://gist.github.com"
        ];
      };
    };

    gh-dash = {
      enable = config.programs.git.enable or false;
      package = pkgs.gh-dash;
    };

    lazygit = {
      enable = config.programs.git.enable or false;
      package = pkgs.lazygit;
    };

    zsh = {
      oh-my-zsh = {
        plugins =
          let
            findPkg =
              pkg:
              (
                let
                  p = if builtins.isString pkg then pkg else lib.getName pkg;
                in
                x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p
              );
          in
          (lib.optionals (config.programs.git.enable or false) [
            "branch"
            "git"
            # "git-auto-fetch"
            # "git-commit"
            "git-escape-magic"
            "gitfast"
            "gitignore"
            "git-lfs"
            # "git-prompt"
          ])
          ++ (lib.optional (
            let
              find = findPkg pkgs.tig;
            in
            builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages
          ) "tig")
          ++ (lib.optional (
            let
              find = findPkg pkgs.git-extras;
            in
            builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages
          ) "git-extras")
          ++ (lib.optional (
            let
              find = findPkg pkgs.gitflow;
            in
            builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages
          ) "git-flow")
          # ++ (lib.optional (
          #   let
          #     find = findPkg pkgs.git-flow-avh;
          #   in
          #   builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages
          # ) "git-flow-avh")
          ++ (lib.optional (
            let
              find = findPkg pkgs.hub;
            in
            builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages
          ) "github")
          ++ (lib.optional (config.programs.git.enable or false) "gh");
      };

      plugins = lib.optionals (config.programs.git.enable or false) (
        with pkgs;
        [
          (
            {
              inherit (zsh-forgit) src;
            }
            // {
              name = "zsh-forgit";
              file = "forgit.plugin.zsh";
            }
          )
        ]
      );
    };

    zed-editor = {
      extensions = lib.optionals (config.programs.git.enable or false) [ "git-firefly" ];

      userSettings = {
        git = lib.mkIf (config.programs.git.enable or false) {
          git_gutter = "tracked_files";
          inline_blame = {
            enabled = true;
          };
        };
      };
    };
  };

  catppuccin = {
    delta = { inherit (config.catppuccin) enable flavor; };

    gh-dash = { inherit (config.catppuccin) enable flavor accent; };

    lazygit = { inherit (config.catppuccin) enable flavor accent; };
  };
}
