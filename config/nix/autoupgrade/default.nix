{
  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";

      operation = "switch";

      flake = "/etc/nixos";
      flags = [
        "--update-input"
        "nixpkgs-stable"
        "--update-input"
        "nixpkgs"
        "--update-input"
        "lix-module"
        "--update-input"
        "home-manager"
        "--update-input"
        "nixos-generators"
        "--update-input"
        "manix"
        "--update-input"
        "helix"
        "--update-input"
        "hyprland"
        "--update-input"
        "hyprland-plugins"
        "--update-input"
        "hycov"
        "--update-input"
        "xdg-desktop-portal-hyprland"
        "--update-input"
        "nur"
        "--update-input"
        "nix-colors"
        "--update-input"
        "spicetify-nix"
        "--update-input"
        "sf-mono-liga-src"
        "--update-input"
        "agenix"
        "--update-input"
        "nix-ld-rs"
        "--update-input"
        "catppuccin"
        "--update-input"
        "wezterm"
        "--update-input"
        "agenix-rekey"
        "--update-input"
        "nixpkgs-small"
        "--update-input"
        "lanzaboote"

        "--commit-lock-file"
      ];
    };
  };
}
