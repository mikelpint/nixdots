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
        retroarch =
          let
            find = lib.lists.findFirst (
              let
                retroarchFull = lib.getName pkgs.retroarchFull;
                retroarch-full = lib.getName pkgs.retroarch-full;
                retroarch-free = lib.getName pkgs.retroarch-free;
                retroarchBare = lib.getName pkgs.retroarchBare;
                retroarch-bare = lib.getName pkgs.retroarch-bare;
                retroarch = lib.getName pkgs.retroarch;
              in
              x:
              let
                name = if lib.attrsets.isDerivation x then lib.getName x else null;
              in
              (
                (name == retroarchFull)
                || (name == retroarch-full)
                || (name == retroarch-free)
                || (name == retroarchBare)
                || (name == retroarch-bare)
                || (name == retroarch)
              )
              && (builtins.pathExists "${lib.getBin x}/bin/retroarch")
            );

            retroarch =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (retroarch != null) {
            executable = "${lib.getBin retroarch}/bin/retroarch";
            profile = "${pkgs.firejail}/etc/firejail/retroarch.profile";
          };
      };
    };
  };
}
