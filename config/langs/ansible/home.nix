{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [
      ansible
      ansible-lint
      ansible-language-server
    ];
  };

  programs =
    let
      find =
        let
          p = lib.getName pkgs.ansible;
        in
        x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p;

      hasAnsible =
        builtins.any find osConfig.environment.systemPackages || builtins.any find config.home.packages;
    in
    {
      zed-editor = {
        extensions = lib.optional hasAnsible "ansible";
      };

      zsh = {
        oh-my-zsh = {
          plugins = lib.optional hasAnsible "ansible";
        };
      };
    };
}
