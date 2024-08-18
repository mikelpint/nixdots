{ config, ... }:
{
  environment = {
    systemPackages = with config.boot.kernelPackages; [
      xpadneo
      xone
    ];
  };
}
