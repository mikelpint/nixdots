{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  security = {
    wrappers = lib.mkIf false {
      gnome-disks =
        let
          find = lib.lists.findFirst (
            let
              gnome-disk-utility = lib.getName pkgs.gnome-disk-utility;
            in
            x: (if lib.attrsets.isDerivation x then lib.getName x else null) == gnome-disk-utility
          );
          gnome-disk-utility =
            find (find null config.environment.systemPackages)
              config.home-manager.users.${user}.home.packages;
        in
        lib.mkIf (gnome-disk-utility != null) {
          enable = true;
          source = "${gnome-disk-utility}/bin/gnome-disks";

          owner = "root";
          group = "root";

          setuid = true;
          setgid = true;

          permissions = "u+rx,g+x,o+x";
          capabilities = "";
        };
    };
  };
}
