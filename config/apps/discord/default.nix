{ pkgs, config, ... }:
{
  programs = {
    firejail = {
      # discord = {
      #   executable = "${pkgs.discord}/bin/discord";
      #   profile = "${config.programs.firejail.package}/etc/firejail/discord.profile";
      # };

      legcord = {
        executable = "${pkgs.legcord}/bin/legcord";
        profile = "${config.programs.firejail.package}/etc/firejail/armcord.profile";
      };
    };
  };
}
