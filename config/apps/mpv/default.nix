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
        mpv =
          let
            mpv =
              if (config.home-manager.users.${user}.programs.mpv.enable or false) then
                config.home-manager.users.${user}.programs.mpv.package or pkgs.mpv
              else
                (
                  let
                    find = lib.lists.findFirst (
                      let
                        mpv-unwrapped = lib.getName pkgs.mpv;
                        mpv = lib.getName pkgs.mpv;
                      in
                      x:
                      (if lib.attrsets.isDerivation x then lib.getName x else null) == mpv-unwrapped || lib.getName == mpv
                    );
                  in
                  find (find null config.environment.systemPackages) config.home-manager.users.${user}.home.packages
                );
          in
          lib.mkIf (mpv != null) {
            executable = "${lib.getBin mpv}/bin/mpv";
            profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
          };
      };
    };
  };
}
