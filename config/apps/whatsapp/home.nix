{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      whatsapp-for-linux
      whatsapp-emoji-font
    ];
  };
}
