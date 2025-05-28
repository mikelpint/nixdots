{ lib, ... }:
{
  imports = [ ./ntp ];

  time = {
    hardwareClockInLocalTime = true;
    timeZone = lib.mkDefault "Europe/Madrid";
  };
}
