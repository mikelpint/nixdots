{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
    };

    zsh = {
      oh-my-zsh = {
        plugins =
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
              pkg: findImpl pkg (findImpl pkg null osConfig.environment.systemPackages) config.home.packages;
          in
          lib.optional (config.programs.vscode.enable or (
            lib.lists.findFirst (pkg: (find null pkg) != null) (
              with pkgs;
              [
                vscode
                vscode-with-extensions
                vscode-fhs
                vscode-fhsWithPackages

                vscodium
                vscodium-fhs
                vscodium-fhsWithPackages
              ]
            ) != null
          )
          ) "vscode";
      };
    };
  };
}
