{ lib, ... }:
{
  boot = {
    loader = {
      grub = {
        efiSupport = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = lib.mkDefault "/boot";
      };
    };
  };
}
