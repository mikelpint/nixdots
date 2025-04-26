{ user, ... }:
{
  imports = [ ../../../../apps/firefox/tmpfs/home.nix ];

  programs = {
    firefox = {
      profiles = {
        ${user} = {
          settings = {
            browser = {
              cache = {
                memory = {
                  enable = true;

                  capacity = 39628.20249; # 41297 - (41606 / (1 + ((80 / 1.16) ^ 0.75))) from https://wiki.archlinux.org/title/Firefox/Tweaks#Turn_off_the_disk_cache
                };
              };
            };
          };
        };
      };
    };
  };
}
