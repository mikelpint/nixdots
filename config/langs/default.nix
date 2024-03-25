{ pkgs, ... }:

{
  imports = [ ./c ./java ./js ./markdown ];

  home = { packages = with pkgs; [ tree-sitter ]; };
}
