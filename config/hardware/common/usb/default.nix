{ pkgs, ... }: {
  boot = { kernelParams = [ "usbcore.autosuspend=-1" ]; };

  services = { gvfs = { enable = true; }; };

  environment = { systemPackages = with pkgs; [ usbutils ]; };
}
