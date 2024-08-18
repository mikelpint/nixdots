{ pkgs, ... }:

{
  imports = [
    ./c
    ./java
    ./js
    ./markdown
    ./python
  ];

  home = {
    packages = with pkgs; [ tree-sitter ];
  };
}
