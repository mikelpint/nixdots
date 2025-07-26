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

    on-click =
      lib.optional (osConfig.networking.networkmanager.enable or false)
        "xdg-terminal-exec ${osConfig.networking.networkmanager.package or pkgs.networkmanager}/bin/nmtui";
  };
}
