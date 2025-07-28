{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  "network" = {
    format-wifi = "󰖩";
    format-ethernet = "󰈀";
    format-linked = "{ifname} (No IP) 󰈀 ";
    format-disconnected = "󰖪";
    tooltip-format = "{essid} {signalStrength}%";
  }
  // (lib.optionalAttrs (osConfig.networking.networkmanager.enable or false) {
    on-click = "xdg-terminal-exec ${
      lib.getBin (osConfig.networking.networkmanager.package or pkgs.networkmanager)
    }/bin/nmtui";
  });
}
