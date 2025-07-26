{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      with ocamlPackages;
      [
        ocaml
      ];
  };

  programs = {
    zed-editor = {
      extensions =
        lib.optionals
          (builtins.any (
            x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.ocaml)
          ) config.home.packages)
          [
            "ocml"
          ];
    };
  };
}
