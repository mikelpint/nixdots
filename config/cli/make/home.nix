{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  programs = {
    zed-editor = {
      extensions = lib.optionals (
        let
          predicate =
            x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.gnumake);
        in
        (lib.lists.count predicate config.home.packages) > 0
        || (lib.lists.count predicate osConfig.environment.systemPackages) > 0
      ) [ "make" ];
    };
  };
}
