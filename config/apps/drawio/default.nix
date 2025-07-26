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
        drawio =
          let
            find = lib.lists.findFirst (
              let
                drawio = lib.getName pkgs.drawio;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == drawio)
              && (builtins.pathExists "${lib.getBin x}/bin/drawio")
            );

            drawio =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (drawio != null) {
            executable = "${lib.getBin drawio}/bin/drawio";
            profile = "${pkgs.firejail}/etc/firejail/drawio.profile";
          };
      };
    };
  };
}
