{ lib, pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: { libcec = super.libcec.override { withLibraspberrypi = true; }; })
    ];
  };

  environment = {
    systemPackages = with pkgs; [ libcec ];
  };

  services = {
    udev = {
      extraRules = ''
        KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
      '';
    };
  };

  systemd = {
    sockets = {
      "cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenFIFO = "/run/cec.fifo";
          SocketGroup = "video";
          SocketMode = "0660";
        };
      };
    };

    services = {
      "cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''${pkgs.libcec}/bin/cec-client -d 1'';
          ExecStop = ''${lib.getBin pkgs.bashInteractive}/bin/sh -c "${lib.getBin pkgs.coreutils}/bin/echo q > /run/cec.fifo"'';
          StandardInput = "socket";
          StandardOutput = "journal";
          Restart = "no";
        };
      };
    };
  };
}
