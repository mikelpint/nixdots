{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [
      json2hcl
      hcl2json
      hcledit

      terraform
      terraform-ls
    ];
  };

  programs =
    let
      findPkg =
        pkg:
        (
          let
            p = if builtins.isString pkg then pkg else lib.getName pkg;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p
        );

      hasTerraform =
        let
          find = findPkg pkgs.terraform;
        in
        builtins.any find config.home.packages || builtins.any find osConfig.environment.systemPackages;
    in
    {
      zed-editor = {
        extensions = lib.optionals hasTerraform [ "terraform" ];
      };

      zsh = {
        oh-my-zsh = {
          plugins = lib.optionals hasTerraform [ "terraform" ];
        };
      };
    };
}
