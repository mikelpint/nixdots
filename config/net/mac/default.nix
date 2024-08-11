# https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/mac-randomize.nix

{ pkgs, lib, ... }:
{
  systemd = {
    services = {
      macchanger = {
        enable = lib.mkDefault false;

        description = "Randomize MAC address";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.mkDefault "${pkgs.macchanger}/bin/macchanger -r wifi";
          ExecStop = lib.mkDefault "${pkgs.macchanger}/bin/macchanger -p wifi";
          RemainAfterExit = true;
        };
      };
    };
  };
}
