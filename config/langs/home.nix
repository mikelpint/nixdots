{ pkgs, ... }:

{
  imports = [
    ./asm/home.nix
    ./c/home.nix
    ./java/home.nix
    ./js/home.nix
    ./markdown/home.nix
    ./python/home.nix
  ];

  home = {
    packages = with pkgs; [ tree-sitter ];
  };
}
