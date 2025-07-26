{
  pkgs,
  home-manager,
  lib,
  config,
  user,
  ...
}:

{
  home = {
    packages = with pkgs; [
      deno

      nodePackages_latest.nodejs
      nodePackages_latest.pnpm

      typescript
      typescript-language-server
      tsx

      eslint
      prettier
      biome
    ];

    sessionVariables = lib.mkIf false (
      (lib.mkIf
        (builtins.any (
          x:
          (if lib.attrsets.isDerivation x then lib.getName x else null)
          == (lib.getName pkgs.nodePackages_latest.npm)
          || builtins.match "^${(lib.getName pkgs.nodejs)}(_[0-9]?)?$" (lib.getName x) != null
        ) config.home.packages)
        (
          let
            NPM_HOME = "/home/${user}/.npm-global";
          in
          {
            inherit NPM_HOME;
            PATH = [ NPM_HOME ];
          }
        )
      )
      // (lib.mkIf
        (builtins.any (
          x:
          (if lib.attrsets.isDerivation x then lib.getName x else null)
          == (lib.getName pkgs.nodePackages_latest.pnpm)
        ) config.home.packages)
        (
          let
            PNPM_HOME = "/home/${user}/.pnpm-global";
          in
          {
            inherit PNPM_HOME;
            PATH = [ PNPM_HOME ];
          }
        )
      )
    );

    activation = {
      npm-prefix =
        if (builtins.isString (config.home.sessionVariables.NPM_HOME or null)) then
          (
            let
              pkg =
                lib.lists.findFirst
                  (
                    x:
                    (if lib.attrsets.isDerivation x then lib.getName x else null)
                    == (lib.getName pkgs.nodePackages_latest.npm)
                  )
                  (
                    lib.lists.findFirst (
                      x:
                      builtins.match "^${(lib.getName pkgs.nodejs)}(_[0-9]?)?$" (
                        if lib.attrsets.isDerivation x then lib.getName x else null
                      ) != null
                    ) pkgs.nodePackages_latest.nodejs config.home.packages
                  );
            in
            home-manager.lib.hm.dag.entryAfter
              [
                "writeBoundary"
                "installPackages"
                (lib.getName pkg)
              ]
              ''
                run ${pkg}/bin/npm set prefix ${config.home.sessionVariables.NPM_HOME}
              ''
          )
        else
          "";

      pnpm-prefix =
        if (builtins.isString (config.home.sessionVariables.PNPM_HOME or null)) then
          (
            let
              pkg = lib.lists.findFirst (
                x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.pnpm)
              ) pkgs.nodePackages_latest.pnpm config.home.packages;
            in
            home-manager.lib.hm.dag.entryAfter
              [
                "writeBoundary"
                "installPackages"
                (lib.getName pkg)
              ]
              ''
                run ${pkg}/bin/pnpm set prefix ${config.home.sessionVariables.PNPM_HOME}
              ''
          )
        else
          "";
    };
  };

  programs = {
    zsh = {
      oh-my-zsh = {
        plugins = lib.optional (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.deno)
        ) config.home.packages) "deno";
      };
    };

    zed-editor =
      (lib.mkIf
        (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.typescript)
        ) config.home.packages)
        {
          extensions = [
            "javascript"
            "typescript"
          ];

          userSettings = {
            languages = {
              JavaScript = {
                formatter = "language_server";
              };

              TypeScript = {
                inlay_hints = {
                  enabled = true;
                  show_parameter_hints = false;
                  show_other_hints = true;
                  show_type_hints = true;
                };

                formatter = "language_server";
              };
            };

            lsp = {
              vtsls = {
                settings = {
                  javascript = {
                    tsserver = {
                      maxTsServerMemory = 16184;
                    };

                    inlayHints = {
                      parameterNames = {
                        enabled = "all";
                        suppressWhenArgumentMatchesName = false;
                      };
                      parameterTypes = {
                        enabled = true;
                      };
                      variableTypes = {
                        enabled = true;
                        suppressWhenTypeMatchesName = true;
                      };
                      propertyDeclarationTypes = {
                        enabled = true;
                      };
                      functionLikeReturnTypes = {
                        enabled = true;
                      };
                      enumMemberValues = {
                        enabled = true;
                      };
                    };
                  };

                  typescript = {
                    tsserver = {
                      maxTsServerMemory = 16184;
                    };

                    inlayHints = {
                      parameterNames = {
                        enabled = "all";
                        suppressWhenArgumentMatchesName = false;
                      };
                      parameterTypes = {
                        enabled = true;
                      };
                      variableTypes = {
                        enabled = true;
                        suppressWhenTypeMatchesName = true;
                      };
                      propertyDeclarationTypes = {
                        enabled = true;
                      };
                      functionLikeReturnTypes = {
                        enabled = true;
                      };
                      enumMemberValues = {
                        enabled = true;
                      };
                    };
                  };
                };
              };
            };
          };
        }
      )
      // (lib.mkIf
        (builtins.any (
          x:
          (if lib.attrsets.isDerivation x then lib.getName x else null)
          == (lib.getName pkgs.typescript-language-server)
        ) config.home.packages)
        {
          extensions = [ "prettier" ];

          userSettings = {
            languages = {
              TypeScript = {
                language_servers = [
                  "typescript-language-server"
                  "!vtsls"
                  "!eslint"
                  "..."
                ];
              };
            };

            lsp = {
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
          };
        }
      )
      // (lib.mkIf
        (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.prettier)
        ) config.home.packages)
        {
          extensions = [ "prettier" ];

          userSettings = {
            languages = {
              JavaScript = {
                formatter = {
                  external = {
                    command = "prettier";
                    arguments = [
                      "--stdin-filepath"
                      "{buffer_path}"
                    ];
                  };
                };
              };

              TypeScript = {
                language_servers = [
                  "prettier"
                  "!typescript-language-server"
                  "!vtsls"
                  "!eslint"
                  "..."
                ];

                formatter = {
                  external = {
                    command = "prettier";
                    arguments = [
                      "--stdin-filepath"
                      "{buffer_path}"
                    ];
                  };
                };
              };
            };
          };
        }
      )
      // (lib.mkIf
        (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.biome)
        ) config.home.packages)
        {
          extensions = [ "biome" ];

          userSettings = {
            languages = {
              TypeScript = {
                language_servers = [
                  "biome"
                  "!typescript-language-server"
                  "!vtsls"
                  "!eslint"
                  "!prettier"
                  "..."
                ];

                formatter = {
                  external = {
                    command = "biome";
                    arguments = [
                      "format"
                      "{buffer_path}"
                    ];
                  };
                };
              };
            };
          };
        }
      )
      // (lib.mkIf
        (builtins.any (
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.deno)
        ) config.home.packages)
        {
          extensions = [ "deno" ];

          userSettings = {
            languages = {
              JavaScript = {
                language_servers = [ "deno" ];
              };

              TypeScript = {
                language_servers = [ "deno" ];
              };

              TSX = {
                language_servers = [ "deno" ];
              };
            };

            lsp = {
              deno = {
                settings = {
                  deno = {
                    enable = true;
                  };
                };
              };
            };
          };
        }
      );
  };
}
