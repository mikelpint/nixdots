{ options, config, lib, pkgs, ... }:
with lib;
with lib.custom;
let cfg = config.presets.dev;
in {
  options = {
    presets = {
      dev = with types; {
        enable = mkBoolOpt false "Enable the development preset";
      };
    };
  };

  config = mkIf cfg.enable {
    apps = {
      insomnia = enabled;
      intellij = enabled;
      mongodb-compass = enabled;
      vscode = true;
    };

    cli = {
      p7zip = enabled;
      unzip = enabled;
      bat = enabled;
      eza = enabled;
      fd = enabled;
      fzf = enabled;
      git = enabled;
      helix = enabled;
      http = enabled;
      jq = enabled;
      onefetch = enabled;
      pop = enabled;
      tree = enabled;
      tmux = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    langs = {
      c = enabled;
      java = enabled;
      javascript = enabled;
      markdown = enabled;
    };

    services = { mongodb = enabled; };

    tools = {
      direnv = enabled;
      gnupg = enabled;
      nix-ld = enabled;
    };

    virtualization = {
      kvm = enabled;
      vbox = enabled;
    };
  };
}
