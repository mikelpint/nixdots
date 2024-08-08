{ pkgs, ... }: {
  home = { packages = with pkgs; [ imv ]; };

  programs = {
    imv = {
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };
}
