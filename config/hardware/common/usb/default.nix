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

    udev = {
      extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee0", MODE="0666"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0664", GROUP="plugdev"
      '';
    };
  };

  environment = {
    systemPackages = with pkgs; [
      usbutils
      libusb1
      libusb-compat-0_1
      python312Packages.pyusb
    ];
  };
}
