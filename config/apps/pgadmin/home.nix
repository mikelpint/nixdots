{ pkgs, lib, ... }:
{
  home = lib.mkIf false {
    packages = with pkgs; [
      pgadmin4-desktopmode
    ];
  };
}
