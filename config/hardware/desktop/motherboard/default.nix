{ config, ... }: {
  environment = {
    systemPackages = with config.boot.kernelPackages;
      [
        acpi_call

        #asus-ec-sensors-unstable
        #asus-wmi-sensors-unstable
      ];
  };
}
