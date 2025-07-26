{
  user,
  lib,
  osConfig,
  config,
  ...
}:
{
  home = lib.mkForce {
    username = user;
    homeDirectory = "/home/${user}";

    sessionPath = [ "$HOME/.local/bin" ];

    inherit (osConfig.system) stateVersion;
  };

  programs = {
    home-manager = {
      enable = true;
    };

    nix-index = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = config.programs.zsh.enable or false;
    };
  };

  imports = [
    ./audio/home.nix
    ./cli/home.nix
    ./env/home.nix
    ./fonts/home.nix
    ./graphics/home.nix
    ./net/home.nix
    ./nix/home.nix
    ./security/home.nix
    ./services/home.nix
    ./tools/home.nix
    ./virtualization/home.nix
  ];
}
