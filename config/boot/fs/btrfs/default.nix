{ lib, pkgs, ... }:
{
  imports = [ ./borg ];

  boot = {
    supportedFilesystems = {
      btrfs = lib.mkDefault true;
    };
  };

  environment = {
    systemPackages = with pkgs; [ btrfs-progs ];
  };
}
