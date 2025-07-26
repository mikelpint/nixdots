{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  programs = {
    firejail = {
      wrappedBinaries =
        let
          findImpl =
            pkg: pred:
            lib.lists.findFirst (
              let
                name = lib.getName pkg;
              in
              x: (if lib.attrsets.isDerivation x then lib.getName x else null) == name && pred x
            );
          find =
            pkg:
            findImpl pkg (findImpl pkg null
              config.environment.systemPackages
            ) config.home-manager.users.${user}.home.packages;
        in
        {
          code =
            let
              found = lib.lists.findFirst (pkg: (find null pkg) != null) (
                with pkgs;
                [
                  vscode
                  vscode-with-extensions
                  vscode-fhs
                  vscode-fhsWithPackages
                ]
              );
            in
            lib.mkIf ((config.home-manager.users.${user}.programs.vscode.enable or false) || (found != null)) {
              executable = "${
                lib.getBin (config.home-manager.users.${user}.programs.vscode.package or found)
              }/bin/code";
              profile = "${pkgs.firejail}/etc/firejail/code.profile";
            };

          vscodium =
            let
              vscodium = lib.lists.findFirst (pkg: (find null pkg) != null) (
                with pkgs;
                [
                  vscodium
                  vscodium-fhs
                  vscodium-fhsWithPackages
                ]
              );
            in
            lib.mkIf (vscodium != null) {
              executable = "${lib.getBin vscodium}/bin/codium";
              profile = "${pkgs.firejail}/etc/firejail/vscodium.profile";
            };
        };
    };
  };
}
