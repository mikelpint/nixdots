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
        gedit =
          let
            find = lib.lists.findFirst (
              let
                gedit = lib.getName pkgs.gedit;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == gedit)
              && (builtins.pathExists "${lib.getBin x}/bin/gedit")
            );

            gedit =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (gedit != null) {
            executable = "${lib.getBin gedit}/bin/gedit";
            profile = "${pkgs.firejail}/etc/firejail/gedit.profile";
          };
      };
    };
  };
}
