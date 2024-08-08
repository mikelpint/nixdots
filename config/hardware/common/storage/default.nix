{ lib, ... }: {
  services = { hdapsd = { enable = lib.mkDefault false; }; };

  boot = { initrd = { availableKernelModules = [ "sd_mod" "ahci" ]; }; };
}
