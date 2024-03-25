{ pkgs, ... }:

let pkgsUnstable = import <nixpkgs-unstable> { };
in {
  environment = { systemPackages = with pkgsUnstable; [ mongodb-compass ]; };
}
