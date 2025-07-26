{ pkgs, ... }:
{
  imports = [
    ./ansible/home.nix
    ./asm/home.nix
    ./c/home.nix
    ./crystal/home.nix
    ./css/home.nix
    ./dot/home.nix
    ./dsv/home.nix
    ./hcl/home.nix
    ./html/home.nix
    ./ini/home.nix
    ./java/home.nix
    ./js/home.nix
    ./log/home.nix
    ./markdown/home.nix
    ./ocaml/home.nix
    ./pkl/home.nix
    ./prisma/home.nix
    ./python/home.nix
    ./sql/home.nix
    ./tex/home.nix
    ./toml/home.nix
    ./xml/home.nix
    ./yaml/home.nix
  ];

  home = {
    packages = with pkgs; [ tree-sitter ];
  };
}
