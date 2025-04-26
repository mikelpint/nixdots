# https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/mac-randomize.nix

{ pkgs, lib, ... }:
let
  interface = "wifi";
in
{
  systemd = {
    services = {
      macchanger = {
        enable = lib.mkDefault false;

        description = "Randomize MAC address on interface '${interface}'";

        wants = [ "network-pre.target" ];
        wantedBy = [ "multi-user.target" ];
        bindsTo = [ "sys-subsystem-net-devices-${interface}.device" ];
        before = [ "network-pre.target" ];
        after = [ "sys-subsystem-net-devices-${interface}.device" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.mkDefault (
            pkgs.writeShellScript "macchanger-service-script" ''
              tmp=$(mktemp)
              ${pkgs.macchanger}/bin/macchanger "${interface}" -s | grep -oP "[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[^ ]*" > "$tmp"
              mac1=$(cat "$tmp" | head -n 1)
              mac2=$(cat "$tmp" | tail -n 1)
              if [ "$mac1" = "$mac2" ]; then
                  if [ "$(cat /sys/class/net/"${interface}"/operstate)" = "up" ]; then
                          ${pkgs.iproute2}/bin/ip link set "${interface}" down &&
                          ${pkgs.macchanger}/bin/macchanger -r "${interface}"
                          ${pkgs.iproute2}/bin/ip link set "${interface}" up
                  else
                      ${pkgs.macchanger}/bin/macchanger -r "${interface}"
                  fi
              fi
            ''
          );
          ExecStop = lib.mkDefault "${pkgs.macchanger}/bin/macchanger -p ${interface}";
          RemainAfterExit = true;
        };
      };
    };
  };
}
