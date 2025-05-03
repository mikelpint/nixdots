{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        # discord = {
        #   executable = "${lib.getBin pkgs.discord}/bin/discord";
        #   profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        # };

        legcord = {
          executable = "${lib.getBin pkgs.legcord}/bin/legcord";
          profile = "${pkgs.firejail}/etc/firejail/armcord.profile";
        };
      };
    };
  };
}
