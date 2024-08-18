# https://github.com/redyf/nixdots/blob/main/flake.nix

{
  description = "mikelpint's dotfiles";

  inputs = {
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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

    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs = {
        hyprland = {
          follows = "hyprland";
        };
      };
    };

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

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
  };

  outputs =
    {
      self,
      helix,
      agenix,
      nixpkgs,
      lix-module,
      nixpkgs-stable,
      nur,
      hyprland,
      home-manager,
      spicetify-nix,
      nix-ld-rs,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (inputs) hyprland nixpkgs;

      hosts = [
        "desktop"
        "laptop"
        "vm"
      ];

      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (
        host:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs hyprland;
          };

          modules = [
            lix-module.nixosModules.default

            ./hosts/${host}/configuration.nix

            catppuccin.nixosModules.catppuccin

            agenix.nixosModules.default

            nur.nixosModules.nur
            nur.hmModules.nur

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs spicetify-nix;
                };

                users = {
                  mikel = {
                    imports = [
                      ./config/home.nix
                      ./hosts/${host}/home.nix
                      catppuccin.homeManagerModules.catppuccin
                    ];
                  };
                };

                backupFileExtension = "backup";
              };
            }
          ];
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              statix
              nixfmt-rfc-style
            ];
          };
        }
      );
    };
}
