{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      win-spice
    ];
  };

  virtualisation = {
    spiceUSBRedirection = {
      enable = lib.mkDefault true;
    };
  };

  services = {
    spice-vdagentd = {
      enable = true;
    };
  };
}
