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
                        (config.home-manager.users.${user}.services.mpd.enable or false)
                        && binExists (config.home-manager.users.${user}.services.mpd.package or pkgs.mpd) name
                      )
                    then
                      config.home-manager.users.${user}.services.mpd.package or pkgs.mpd
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
              bin = "mpd";

              ps = with pkgs; [
                mpd
                mpd-small
              ];
            }
          ]
      );
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts =
        (lib.optional (config.home-manager.users.${user}.services.mpd.enable or false) (
          config.home-manager.users.${user}.services.mpd.network.port or 6600
        ))
        ++ (lib.optional (config.services.mpd.enable or false) (config.services.mpd.network.port or 6600));
    };
  };
}
