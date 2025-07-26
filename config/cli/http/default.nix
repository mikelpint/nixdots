{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  imports = [ ../../system/http/default.nix ];

  environment = {
    systemPackages = with pkgs; [
      aria2
    ];
  };

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
          aria2c =
            let
              aria2c = find null pkgs.aria2;
            in
            lib.mkIf (aria2c != null) {
              executable = "${lib.getBin aria2c}/bin/aria2c";
              profile = "${pkgs.firejail}/etc/firejail/aria2c.profile";
            };
        };
    };
  };
}
