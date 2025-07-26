{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  hasDocker = osConfig.virtualization.docker.enable or false;
  hasDockerCompose =
    let
      any = builtins.any (
        x:
        let
          p = lib.getName pkgs.docker-compose;
        in
        (if lib.attrsets.isDerivation x then lib.getName x else null) == p
      );
    in
    (any config.home.packages) || (any osConfig.environment.systemPackages);
in
{
  home = {
    packages = lib.optionals hasDocker (
      with pkgs;
      [
        lazydocker
      ]
    );
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals hasDocker [
        "dockerfile"
      ];
    };

    zsh = {
      oh-my-zsh = {
        plugins = lib.optionals hasDockerCompose [
          "docker"
        ];
      };
    };
  };
}
