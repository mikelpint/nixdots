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
                amule = lib.getName pkgs.amule;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == amule)
              && (builtins.pathExists "${lib.getBin x}/bin/amule")
            );

            amule =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (amule != null) {
            executable = "${lib.getBin amule}/bin/amule";
            profile = "${pkgs.firejail}/etc/firejail/amule.profile";
          };
      };
    };
  };
}
