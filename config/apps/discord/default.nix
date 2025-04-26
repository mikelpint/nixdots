{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        # discord = {
        #   executable = "${pkgs.discord}/bin/discord";
        #   profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        # };

        legcord = {
          executable = "${pkgs.legcord}/bin/legcord";
          profile = "${pkgs.firejail}/etc/firejail/armcord.profile";
        };
      };
    };
  };
}
