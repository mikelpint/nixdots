{ pkgs, ... }:

{
  programs = {
    steam = {
      extraCompatPackages = with pkgs; [ proton-ge-bin ];

      extest = {
        enable = true;
      };

      dedicatedServer = {
        openFirewall = true;
      };

      localNetworkGameTransfers = {
        openFirewall = false;
      };
    };
  };
}
