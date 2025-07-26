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
        thunar =
          let
            thunar =
              if (config.programs.thunar.enable or false) then
                config.programs.thunar.package or pkgs.xfce.thunar
              else
                (
                  let
                    find = lib.lists.findFirst (
                      let
                        thunar = lib.getName pkgs.xfce.thunar;
                        thunar-bare = lib.getName pkgs.xfce.thunar-bare;
                      in
                      x:
                      let
                        name = if lib.attrsets.isDerivation x then lib.getName x else null;
                      in
                      name == thunar || name == thunar-bare
                    );
                  in
                  find (find null config.environment.systemPackages) config.home-manager.users.${user}.home.packages
                );
          in
          lib.mkIf (thunar != null) {
            executable = "${lib.getBin thunar}/bin/thunar";
            profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
          };
      };
    };
  };
}
