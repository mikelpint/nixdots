{ pkgs, ... }:

{
  home = { packages = with pkgs; [ wget curl openssl ]; };
}
