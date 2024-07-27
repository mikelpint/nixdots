{ lib, ... }: {
  imports = [ ./modules ./patches ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = [ "video4linux" ];
  };
}