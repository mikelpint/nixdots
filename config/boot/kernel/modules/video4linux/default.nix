{ config, ... }: {
  boot = {
    kernelModules = [ "v4l2loopback" "video4linux" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  };
}
