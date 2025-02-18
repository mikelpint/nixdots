{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [ libarchive p7zip unzip unrar ];
  };
}
