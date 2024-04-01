{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      font-manager
      dejavu_fonts
      font-awesome
      fira-code-symbols
      (iosevka-bin.override { variant = "Aile"; })
      material-design-icons
      (nerdfonts.override { fonts = [ "FiraMono" "JetBrainsMono" ]; })
      nerdfix
      noto-fonts
      powerline-symbols
    ];
  };
}
