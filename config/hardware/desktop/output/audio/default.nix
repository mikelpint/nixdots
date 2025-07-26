{ pkgs, ... }:
{
  imports = [
    ../../../common/output/audio
    ../../../common/output/audio/tweaks/lowlatency
    ../../../common/output/audio/tweaks/virtual-surround

    ../../../../audio/realtime
  ];

  boot = {
    postBootCommands = ''
      ${pkgs.pciutils}/bin/setpci -v -s 0f:00.4 latency_timer=ff
    '';
  };
}
