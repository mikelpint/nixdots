{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [ beekeeper-studio ];
  };

  nixpkgs = {
    config = {
      permittedInsecurePackages =
        let
          find = lib.lists.findFirst (
            let
              beekeeper-studio = lib.getName pkgs.beekeeper-studio;
            in
            x: (if lib.attrsets.isDerivation x then lib.getName x else null) == beekeeper-studio
          );
          pkg = find (find null osConfig.environment.systemPackages) config.home.packages;
        in
        lib.optional (pkg != null) "${lib.getName pkg}-${lib.getVersion pkg}";
    };
  };
}
