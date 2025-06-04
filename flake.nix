# https://github.com/redyf/nixdots/blob/main/flake.nix

{
  description = "mikelpint's dotfiles";

  inputs = {
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-small = {
      url = "github:NixOs/nixpkgs/nixos-unstable-small";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    manix = {
      url = "github:nix-community/manix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
    };

    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass?ref=refs/tags/v0.8.1";
    #   inputs = {
    #     hyprland = {
    #       follows = "hyprland";
    #     };
    #   };
    # };

    waybar-hyprland = {
      url = "github:hyprwm/hyprland";
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    swww = {
      url = "github:LGFae/swww";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      agenix,
      agenix-rekey,
      nur,
      home-manager,
      spicetify-nix,
      catppuccin,
      lanzaboote,
      treefmt-nix,
      nixcord,
      ...
    }@inputs:
    let
      inherit (inputs) hyprland nixpkgs;

      hosts = [
        "desktop"
        "laptop"
        {
          enabled = false;

          name = "rpi3bp";
          system = "aarch64-linux";
        }
      ];

      defaultSystem = "x86_64-linux";
      defaultUser = "mikel";

      systems = nixpkgs.lib.lists.unique (
        builtins.map (
          host: if builtins.isString host then defaultSystem else (host.system or defaultSystem)
        ) hosts
      );

      eachHost =
        f:
        builtins.mapAttrs f (
          nixpkgs.lib.listToAttrs (
            builtins.map (
              host:
              if builtins.isString host then
                {
                  name = host;
                  value = {
                    enabled = true;

                    system = defaultSystem;
                    user = defaultUser;
                  };
                }
              else
                {
                  inherit (host) name;
                  value = {
                    enabled = true;

                    system = host.system or defaultSystem;
                    user = host.user or defaultUser;
                  };
                }
            ) (builtins.filter (host: if builtins.isString host then true else host.enabled or true) hosts)
          )
        );

      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      formatter = eachSystem (pkgs: treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix);

      checks = eachSystem (pkgs: {
        formatting = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.check self;
      });

      nixosConfigurations = eachHost (
        name: value:
        nixpkgs.lib.nixosSystem {
          inherit (value) system;

          specialArgs = {
            inherit inputs self hyprland;
            inherit (value) user;
          };

          modules = [
            # lix-module.nixosModules.default

            ./hosts/${name}/configuration.nix

            lanzaboote.nixosModules.lanzaboote

            catppuccin.nixosModules.catppuccin

            agenix.nixosModules.default
            agenix-rekey.nixosModules.default

            nur.modules.nixos.default
            # nur.modules.homeManager.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    inputs
                    self
                    hyprland
                    home-manager
                    spicetify-nix
                    ;
                  inherit (value) user;
                };

                users = {
                  ${value.user} = {
                    imports = [
                      ./config/home.nix
                      ./hosts/${name}/home.nix
                      catppuccin.homeModules.catppuccin
                    ];
                  };
                };

                sharedModules = [
                  nixcord.homeModules.nixcord
                ];

                backupFileExtension = "hm-backup";
              };
            }
          ];
        }
      );

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        inherit (self) nixosConfigurations;
        agePackage = p: p.age;
      };

      devShells = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ agenix-rekey.overlays.default ];
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              deadnix
              statix
              treefmt-nix
              agenix-rekey
            ];
          };
        }
      );
    };
}
