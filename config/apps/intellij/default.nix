{ pkgs, ... }:
let
  idea = with pkgs; with jetbrains; (plugins.addPlugins idea-ultimate [ "mermaid" ]);
  inherit (pkgs.jetbrains) clion;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        clion = {
          executable = "${clion}/bin/clion";
          profile = "${pkgs.firejail}/etc/firejail/clion.profile";
        };

        idea-ultimate = {
          executable = "${idea}/bin/idea-ultimate";
          profile = "${pkgs.firejail}/etc/firejail/idea.profile";
        };
      };
    };
  };
}
