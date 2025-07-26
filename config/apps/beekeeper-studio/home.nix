{ pkgs, lib, ... }:
{
  home = lib.mkIf false {
    packages = with pkgs; [ beekeeper-studio ];
  };
}
