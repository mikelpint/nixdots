{ config, ... }: {
  environment = { systemPackages = [ config.boot.kernelPackages.ryzen-smu ]; };

  programs = { ryzen-smu = { enable = true; }; };

  boot = { initrd = { kernelModules = [ "ryzen-smu" ]; }; };
}
