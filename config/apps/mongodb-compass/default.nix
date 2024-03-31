{ pkgs, ... }:

let pkgsUnstable = import <nixpkgs-unstable> { };
in {
  home = { packages = with pkgsUnstable; [ mongodb-compass ]; };
}
