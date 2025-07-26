{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
{
  home = {
    shellAliases =
      let
        find = lib.lists.findFirst (
          let
            duf = lib.getName pkgs.duf;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == duf
        );

        duf = find (find null osConfig.environment.systemPackages) config.home.packages;
      in
      lib.mkIf (duf != null) {
        df = "${duf}/bin/duf";
      };
  };
}
