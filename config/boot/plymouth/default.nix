{ pkgs, lib, ... }:
{
  boot = {
    initrd = {
      systemd = {
        enable = true;
      };
    };
  };

  boot = {
    plymouth = {
      enable = lib.mkDefault true;

      font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
    };
  };

  catppuccin = {
    plymouth = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
