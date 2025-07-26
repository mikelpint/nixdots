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
        filezilla =
          let
            find = lib.lists.findFirst (
              let
                filezilla = lib.getName pkgs.filezilla;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == filezilla)
              && (builtins.pathExists "${lib.getBin x}/bin/filezilla")
            );

            filezilla =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (filezilla != null) {
            executable = "${lib.getBin filezilla}/bin/filezilla";
            profile = "${pkgs.firejail}/etc/firejail/filezilla.profile";
          };
      };
    };
  };
}
