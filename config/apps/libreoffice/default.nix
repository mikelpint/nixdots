{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      hunspellDicts.es_ES
    ];
  };
}
