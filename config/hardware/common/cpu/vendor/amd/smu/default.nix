{ config, ... }:
{
  environment = {
    systemPackages = [ config.boot.kernelPackages.ryzen-smu ];
  };

  hardware = {
    cpu = {
      amd = {
        ryzen-smu = {
          enable = true;
        };
      };
    };
  };

  boot = {
    initrd = {
      kernelModules = [ "ryzen-smu" ];
    };
  };
}
