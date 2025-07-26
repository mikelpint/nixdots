{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
{
  programs = {
    zsh = {
      oh-my-zsh = {
        plugins =
          let
            any = builtins.any (
              x:
              let
                procs = lib.getName pkgs.procs;
              in
              (if lib.attrsets.isDerivation x then lib.getName x else null) == procs
            );
          in
          lib.optional ((any config.home.packages) || (any osConfig.environment.systemPackages)) "procs";
      };
    };
  };
}
