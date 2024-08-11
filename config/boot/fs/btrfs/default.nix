{ pkgs, ... }:
{
  imports = [ ./borg ];

  boot = {
    supportedFilesystems = [ "btrfs" ];
  };

  environment = {
    systemPackages = with pkgs; [ btrfs-progs ];
  };
}
