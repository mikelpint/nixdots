{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [ file ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        file =
          let
            find = lib.lists.findFirst (
              let
                file = lib.getName pkgs.file;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == file)
              && (builtins.pathExists "${lib.getBin x}/bin/file")
            );

            file =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (file != null) {
            executable = "${lib.getBin file}/bin/file";
            profile = "${pkgs.firejail}/etc/firejail/file.profile";
          };
      };
    };
  };
}
