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
        zathura =
          let
            zathura =
              if (config.home-manager.users.${user}.programs.zathura.enable or false) then
                config.home-manager.users.${user}.programs.zathura.package or pkgs.zathura
              else
                (
                  let
                    find = lib.lists.findFirst (
                      let
                        zathura = lib.getName pkgs.zathura;
                      in
                      x: (if lib.attrsets.isDerivation x then lib.getName x else null) == zathura
                    );
                  in
                  find (find null config.environment.systemPackages) config.home-manager.users.${user}.home.packages
                );
          in
          lib.mkIf (zathura != null) {
            executable = "${lib.getBin zathura}/bin/zathura";
            profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
          };
      };
    };
  };
}
