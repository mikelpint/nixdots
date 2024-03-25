# https://github.com/redyf/nixdots/blob/main/flake.nix

{
  description = "mikelpint's dotfiles";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };

    nixos-generators = { url = "github:nix-community/nixos-generators"; };
    nixos-generators = { inputs = { nixpkgs = { follows = "nixpkgs"; }; }; };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    manix = {
      url = "github:nix-community/manix";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };

    hyprland = { url = "github:hyprwm/hyprland"; };
    waybar-hyprland = { url = "github:hyprwm/hyprland"; };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
    };

    nur = { url = "github:nix-community/NUR"; };

    nix-colors = { url = "github:misterio77/nix-colors"; };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };

    disko = { url = "github:nix-community/disko"; };

    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    monolisa-script = {
      url = "github:redyf/test2";
      flake = false;
    };
  };

  outputs = inputs:
    let
      inherit (inputs) hyprland nixpkgs;
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: true;
        packageOverrides = pkgs: {
          nur = import (builtins.fetchTarball {
            url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
            sha256 =
              "sha256:1gr3l5fcjsd7j9g6k9jamby684k356a36h82cwck2vcxf8yw8xa0";
          }) { inherit pkgs; };
        };
      };

      overlays = with inputs; [
        neovim-nightly-overlay.overlay
        (final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = inputs.sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };

          monolisa-script = prev.stdenvNoCC.mkDerivation {
            pname = "monolisa";
            version = "dev";
            src = monolisa-script;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.ttf $out/share/fonts/opentype/
            '';
          };
        })
      ];

      systems = {
        modules = {
          nixos = with inputs; [
            spicetify-nix.nixosModule
            disko.nixosModules.disko
          ];
        };
      };

      systems = {
        hosts = {
          laptop = {
            modules = with inputs;
              [
                (import ./disks/default.nix {
                  inherit lib;
                  device = "/dev/nvme0n1";
                  luks = true;
                  swap = true;
                })
              ];
          };

          desktop = {
            modules = with inputs;
              [
                (import ./disks/default.nix {
                  inherit lib;
                  device = "/dev/nvme0n1";
                })
              ];
          };

          test = {
            modules = with inputs;
              [
                (import ./disks/default.nix {
                  inherit lib;
                  device = "/dev/vda";
                })
              ];
          };
        };
      };

      templates = import ./templates { };

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ git nixpkgs-fmt statix ];
          };
        });

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      };
    };
}
