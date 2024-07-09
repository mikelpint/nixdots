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
      (nerdfonts.override { fonts = [ "Ubuntu" "FiraMono" "JetBrainsMono" ]; })
      nerdfix
      noto-fonts
      powerline-symbols
    ];
  };
}
