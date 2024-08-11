{
  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";

      operation = "switch";

      flake = "/etc/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
        "--update-input"
        "--commit-lock-file"
      ];
    };
  };
}
