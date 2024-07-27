# https://github.com/redyf/nixdots/blob/main/flake.nix

{
  description = "mikelpint's dotfiles";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    helix = { url = "github:helix-editor/helix"; };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = { hyprland = { follows = "hyprland"; }; };
    };

    waybar-hyprland = { url = "github:hyprwm/hyprland"; };

    xdg-desktop-portal-hyprland = {
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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };

    nix-ld-rs = { url = "github:nix-community/nix-ld-rs"; };

    catppuccin = { url = "github:catppuccin/nix"; };
  };

  outputs = { self, helix, sops-nix, nixpkgs, nur, hyprland, home-manager
    , spicetify-nix, disko, nix-ld-rs, catppuccin, ... }@inputs:
    let
      inherit (inputs) hyprland nixpkgs;

      hosts = [ "desktop" "laptop" "vm" ];
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (host:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs hyprland spicetify-nix disko; };

          modules = [
            ./hosts/${host}/configuration.nix

            catppuccin.nixosModules.catppuccin

            sops-nix.nixosModules.sops

            nur.nixosModules.nur
            nur.hmModules.nur

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs spicetify-nix disko; };

                users = {
                  mikel = {
                    imports = [
                      ./config/home.nix
                      ./hosts/${host}/home.nix
                      catppuccin.homeManagerModules.catppuccin
                    ];
                  };
                };

                backupFileExtension = "bck";
              };
            }

            hyprland.nixosModules.default
            { programs = { hyprland = { enable = true; }; }; }

            disko.nixosModules.disko
          ];
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell { buildInputs = with pkgs; [ git statix ]; };
        });
    };
}
