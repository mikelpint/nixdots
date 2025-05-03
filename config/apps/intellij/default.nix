{ pkgs, lib, ... }:
let
  idea = with pkgs; with jetbrains; (plugins.addPlugins idea-ultimate [ "mermaid" ]);
  inherit (pkgs.jetbrains) clion;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        clion = {
          executable = "${lib.getBin clion}/bin/clion";
          profile = "${pkgs.firejail}/etc/firejail/clion.profile";
        };

        idea-ultimate = {
          executable = "${lib.getBin idea}/bin/idea-ultimate";
          profile = "${pkgs.firejail}/etc/firejail/idea.profile";
        };
      };
    };
  };
}
