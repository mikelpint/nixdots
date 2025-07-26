{ pkgs, ... }:
let
  idea = with pkgs; with jetbrains; (plugins.addPlugins idea-ultimate [ "mermaid" ]);
  # idea = pkgs.jetbrains.idea-ultimate;
  inherit (pkgs.jetbrains) clion;
in
{
  home = {
    packages = [
      idea
      clion
    ];
  };
}
