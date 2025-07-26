{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      crystal
      crystal2nix
      crystalline
      shards
    ];
  };

  programs = {
    zed-editor = {
      extensions = [
        "crystal"
      ];
    };
  };
}
