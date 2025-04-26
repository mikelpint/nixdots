{ pkgs, ... }:
let
  package = pkgs.libreoffice-fresh;
in{
  home = {
    packages = with pkgs; [
      package
      hunspell
      hunspellDicts.en_US
      hunspellDicts.es_ES
    ];
  };
}
