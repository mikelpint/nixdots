{ pkgs, ... }: {
  imports = [ ./borg ];

  boot = { supportedFilesystems = [ "btrfs" ]; };

  enviroment = { systemPackages = with pkgs; [ btrfs-progs ]; };
}
