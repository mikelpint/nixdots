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
      wrappedBinaries = builtins.listToAttrs (
        let
          binExists = pkg: bin: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";
        in
        builtins.flatMap
          (
            { bin, ps }:
            builtins.map (name: {
              inherit name;
              value =
                let
                  pkg =
                    if
                      (
                        (config.home-manager.users.${user}.programs.imv.enable or false)
                        && binExists (config.home-manager.users.${user}.programs.imv.package or pkgs.imv) name
                      )
                    then
                      config.home-manager.users.${user}.programs.imv.package or pkgs.imv
                    else
                      lib.lists.findFirst (
                        pkg:
                        let
                          name = lib.getName pkg;
                          pred =
                            x: ((if lib.attrsets.isDerivation x then lib.getName x else null) == name) && binExists x name;
                        in
                        (lib.lists.findFirst pred (lib.lists.findFirst pred null
                          config.environment.systemPackages
                        ) config.home-manager.users.${user}.home.packages) != null
                      ) null ps;
                in
                lib.mkIf (pkg != null) {
                  executable = "${lib.getBin pkg}/bin/${name}";
                  profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
                };
            }) (lib.lists.toList bin)
          )
          [
            {
              bin = "imv";

              ps = with pkgs; [
                imv
              ];
            }
          ]
      );
    };
  };
}
