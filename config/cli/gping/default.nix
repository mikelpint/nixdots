{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      gping
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        gping =
          let
            find = lib.lists.findFirst (
              let
                gping = lib.getName pkgs.gping;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == gping)
              && (builtins.pathExists "${lib.getBin x}/bin/gping")
            );

            gping =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (gping != null) {
            executable = "${lib.getBin gping}/bin/gping";
            profile = "${pkgs.firejail}/etc/firejail/ping-hardedned.inc.profile";
          };
      };
    };
  };
}
