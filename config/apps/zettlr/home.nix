{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      zettlr
      pandoc
    ];
  };
}
