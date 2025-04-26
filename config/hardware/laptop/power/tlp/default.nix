{ config, lib, ... }:

{
  services = {
    tlp = {
      enable =
        (lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
        || !config.services.power-profiles-daemon.enable;

      settings = {
        TLP_ENABLE = 1;
        TLP_WARN_LEVEL = 3;
        TLP_MSG_COLORS = "91 93 1 92";

        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 0;

        NMI_WATCHDOG = 0;

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        ENERGY_PERF_POLICY_ON_AC = "default";
        ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        SCHED_POWERSAVE_ON_AC = 0;
        SCHED_POWERSAVE_ON_BAT = 1;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        CPU_SCALING_MIN_FREQ_ON_AC = 0;
        CPU_SCALING_MAX_FREQ_ON_AC = "";
        CPU_SCALING_MIN_FREQ_ON_BAT = 0;
        CPU_SCALING_MAX_FREQ_ON_BAT = "";

        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;

        DISK_IDLE_SECS_ON_AC = 0;
        DISK_IDLE_SECS_ON_BAT = 2;

        DISK_IOSCHED = "keep keep";

        SATA_LINKPWR_ON_AC = "med_power_with_dipm min_power";
        SATA_LINKPWR_ON_BAT = "med_power_with_dipm min_power";

        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "on";

        AHCI_RUNTIME_PM_TIMEOUT = 15;

        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersave";

        MAX_LOST_WORK_SECS_ON_AC = 15;
        MAX_LOST_WORK_SECS_ON_BAT = 60;

        RADEON_POWER_PROFILE_ON_AC = "default";
        RADEON_POWER_PROFILE_ON_BAT = "low";

        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";

        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        WOL_DISABLE = "Y";

        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;

        SOUND_POWER_SAVE_CONTROLLER = "Y";

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        RUNTIME_PM_DRIVER_BLACKLIST = "nouveau";

        USB_AUTOSUSPEND = 1;
        USB_BLACKLIST_BTUSB = 0;
        USB_BLACKLIST_PHONE = 0;
        USB_BLACKLIST_PRINTER = 0;
        USB_BLACKLIST_WWAN = 0;

        RESTORE_DEVICE_STATE_ON_STARTUP = 0;
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
        DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth";
      };
    };
  };

  boot = lib.mkIf config.services.tlp.enable {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
