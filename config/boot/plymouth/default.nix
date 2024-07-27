{ pkgs, ... }: {
  boot = {
    plymouth = {
      enable = true;

      font =
        "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";

      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };
}
