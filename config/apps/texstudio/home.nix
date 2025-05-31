{ pkgs, ... }:
{
  imports = [ ../../langs/tex/home.nix ];

  home = {
    packages = with pkgs; [ texstudio ];
  };
}
