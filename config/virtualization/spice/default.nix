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
    udev = {
      extraRules = ''
        SUBSYSTEM=="usb", GROUP="spice", MODE="0660"
        SUBSYSTEM=="usb_device", GROUP="spice", MODE="0660"
      '';
    };
  };
}
