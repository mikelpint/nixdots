{ lib, pkgs, ... }:
{
  boot = {
    supportedFilesystems = {
      ntfs = lib.mkDefault true;
    };
  };

  environment = {
    systemPackages = with pkgs; [ ntfs3g ];
  };
}
