{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      kdePackages.k3b
    ];
  };
}
