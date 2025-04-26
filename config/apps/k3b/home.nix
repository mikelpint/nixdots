{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      kdePackages.k3b
      dvdplusrwtools
      # dvd-vr
    ];
  };
}
