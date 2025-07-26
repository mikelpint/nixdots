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
        obs-studio =
          let
            obs =
              if (config.home-manager.users.${user}.programs.obs-studio.enable or false) then
                config.home-manager.users.${user}.programs.obs-studio.package or pkgs.obs-studio
              else if (config.programs.obs-studio.enable or false) then
                config.programs.obs-studio.package or pkgs.obs-studio
              else
                (
                  let
                    find = lib.lists.findFirst (
                      let
                        obs-studio = lib.getName pkgs.obs-studio;
                      in
                      x: (if lib.attrsets.isDerivation x then lib.getName x else null) == obs-studio
                    );
                  in
                  find (find null config.environment.systemPackages) config.home-manager.users.${user}.home.packages
                );
          in
          lib.mkIf (obs != null) {
            executable = "${lib.getBin obs}/bin/obs";
            profile = "${pkgs.firejail}/etc/firejail/obs.profile";
          };
      };
    };
  };
}
