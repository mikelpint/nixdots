{ pkgs, ... }:
let
  idea = with pkgs; with jetbrains; ( plugins.addPlugins idea-ultimate [ "mermaid" ]);
  inherit (pkgs.jetbrains) clion;
in {
  home = {
    packages =
      [
        idea
        clion
      ];
  };
}
