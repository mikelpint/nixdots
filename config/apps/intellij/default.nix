{ pkgs, config, ... }:
let
  idea = with pkgs; with jetbrains; (plugins.addPlugins idea-ultimate [ "mermaid" ]);
  inherit (pkgs.jetbrains) clion;
in
{
  home = {
    packages = [
      idea
      clion
    ];
  };

  programs = {
    firejail = {
      clion = {
        executable = "${clion}/bin/clion";
        profile = "${config.programs.firejail.package}/etc/firejail/clion.profile";
      };

      idea-ultimate = {
        executable = "${idea}/bin/idea-ultimate";
        profile = "${config.programs.firejail.package}/etc/firejail/idea.profile";
      };
    };
  };
}
