{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tomlq
      toml2nix
      toml2json
    ];
  };

  programs = {
    zed-editor = {
      extensions = [ "toml" ];
    };
  };
}
