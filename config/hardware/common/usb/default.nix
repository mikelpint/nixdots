{ pkgs, ... }:
{
  boot = {
    kernelParams = [ "usbcore.autosuspend=-1" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "uas"
        "usb_storage"
      ];
    };
  };

  services = {
    gvfs = {
      enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [ usbutils ];
  };
}
