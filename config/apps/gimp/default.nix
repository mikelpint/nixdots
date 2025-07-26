{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        gimp =
          let
            find =
              pkg:
              lib.lists.findFirst (
                let
                  gimp = lib.getName pkg;
                in
                x:
                ((if lib.attrsets.isDerivation x then lib.getName x else null) == gimp)
                && (builtins.pathExists "${lib.getBin x}/bin/gimp")
              );

            gimp =
              lib.lists.findFirst
                (
                  pkg:
                  find pkg (find null config.environment.systemPackages)
                    config.home-manager.users.${user}.home.packages
                )
                (
                  with pkgs;
                  [
                    gimp3-with-plugins
                    gimp3
                    gimp-with-plugins
                    gimp
                  ]
                );
          in
          lib.mkIf (gimp != null) {
            executable = "${lib.getBin gimp}/bin/gimp";
            profile = "${pkgs.firejail}/etc/firejail/gimp${
              let
                matches = builtins.match "^([0-9])\\.([0-9]+)(\\.[0-9]+)?$" (lib.getVersion gimp);
                version = lib.optionalString (
                  matches != null
                ) "${(builtins.elemAt matches 1)}.${(builtins.elemAt matches 2)}";
              in
              lib.optionalString (version == "2.8" || version == "2.10") "-${version}"
            }.profile";
          };
      };
    };
  };
}
