{lib, ...}: {
  time = {
    hardwareClockInLocalTime = true;
    timeZone = lib.mkDefault "Europe/Madrid";
  };
}
