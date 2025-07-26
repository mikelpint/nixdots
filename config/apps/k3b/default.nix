{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  imports = [ ../../hardware/common/storage/dvd ];

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
                    if ((config.programs.k3b.enable or false) && binExists pkgs.k3b name) then
                      # config.programs.k3b.package or
                      pkgs.k3b
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
              bin = "k3b";

              ps = with pkgs; [
                k3b
              ];
            }
          ]
      );
    };
  };
}
