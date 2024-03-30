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
  };

  outputs = { self, nixpkgs, hyprland, home-manager,
    spicetify-nix, disko, ... }@inputs:
    let
      inherit (inputs) hyprland nixpkgs;
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hyprland spicetify-nix disko; };
          modules = [
            ./hosts/desktop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = false;
                extraSpecialArgs = { inherit inputs spicetify-nix disko; };
                users = { mikel = ./config/home.nix; };
              };
            }
            hyprland.nixosModules.default
            { programs = { hyprland = { enable = true; }; }; }
            disko.nixosModules.disko
          ];
        };
      };

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell { buildInputs = with pkgs; [ git statix ]; };
        });
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    };
}
