{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  security = {
    wrappers = lib.mkIf false {
      gparted =
        let
          find = lib.lists.findFirst (
            let
              gparted = lib.getName pkgs.gparted;
            in
            x: (if lib.attrsets.isDerivation x then lib.getName x else null) == gparted
          );
          gparted =
            find (find null config.environment.systemPackages)
              config.home-manager.users.${user}.home.packages;
        in
        lib.mkIf (gparted != null) {
          enable = true;
          source = "${gparted}/bin/gparted";

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
