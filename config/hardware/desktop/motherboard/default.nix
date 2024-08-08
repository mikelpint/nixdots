{ pkgs, ... }: {
  environment = {
    systemPackages = with config.boot.kernelPackages; [
      acpi-call

      asus-ec-sensors-unstable
      asus-wmi-sensors-unstable
    ];
  };
}
