{
  user,
  config,
  lib,
  ...
}:
{
  imports = [
    ./dbus
    ./dconf
    ./git
    ./http
    ./hwutils
    ./lib
    ./lsof
    ./nix-ld
    ./nmap
  ];

  system = {
    name = lib.mkDefault (lib.strings.removeSuffix user config.networking.hostName);
    stateVersion = "25.11";

    tools = {
      # nixos-build-vms = {
      #   enable = lib.mkDefault true;
      # };

      # nixos-enter = {
      #   enable = lib.mkDefault true;
      # };

      # nixos-nixos-generate-config = {
      #   enable = lib.mkDefault true;
      # };

      # nixos-install = {
      #   enable = lib.mkDefault true;
      # };

      # nixos-rebuild = {
      #   enable = lib.mkDefault true;
      # };

      # nixos-version = {
      #   enable = lib.mkDefault true;
      # };
    };
  };
}
