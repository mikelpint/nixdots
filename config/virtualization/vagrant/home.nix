{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  home = lib.mkIf false {
    packages = with pkgs; [
      (vagrant.override {
        # withLibvirt = false; # https://github.com/NixOS/nixpkgs/issues/348938#issuecomment-2418403735
        withLibvirt = true;
      })
    ];
  };

  programs =
    let
      any = builtins.any (
        x:
        let
          vagrant = lib.getName pkgs.vagrant;
        in
        (if lib.attrsets.isDerivation x then lib.getName x else null) == vagrant
      );
    in
    {
      zed-editor = {
        extensions = lib.optional (
          (any config.home.packages) || (any osConfig.environment.systemPackages)
        ) "ruby";
      };

      zsh = {
        oh-my-zsh = {
          plugins = lib.optionals ((any config.home.packages) || (any osConfig.environment.systemPackages)) [
            "vagrant"
            "vagrant-prompt"
          ];
        };
      };
    };
}
