{
  imports = [
    ./auto-cpufreq
    ./tlp
  ];

  services = {
    power-profiles-daemon = {
      enable = false;
    };
  };

  powerManagement = {
    powertop = {
      enable = true;
    };
  };
}
