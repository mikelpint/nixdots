{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ jetbrains.jdk ];
  };
}
