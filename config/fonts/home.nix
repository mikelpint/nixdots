{ pkgs, ... }:

{
  fonts = { fontconfig = { enable = true; }; };

  home = {
    packages = with pkgs; [
      font-manager
      dejavu_fonts
      font-awesome
      fira-code-symbols
      (iosevka-bin.override { variant = "Aile"; })
      material-design-icons
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.jetbrains-mono
      nerdfix
      noto-fonts
      powerline-symbols
    ];
  };
}
