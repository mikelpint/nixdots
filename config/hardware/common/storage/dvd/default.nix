{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      dvdplusrwtools
      dvd-vr
    ];
  };
}
