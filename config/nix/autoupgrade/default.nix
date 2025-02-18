{
  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";

      operation = "switch";

      flake = "/etc/nixos";
      flags = [ "flake" "update" "--commit-lock-file" ];
    };
  };
}
