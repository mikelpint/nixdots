# https://wiki.archlinux.org/title/YubiKey#Start_Yubico_Authenticator_on_insertion

{ pkgs, ... }:

let device = "dev-yubikey.device";
in {
  systemd = {
    user = {
      services = {
        yubioath-desktop = {
          Unit = {
            Description =
              "Start Yubico Authenticator when a Yubikey is plugged in and stop when unplugged.";
            StopPropagatedFrom = "${device}";
          };

          Install = { WantedBy = [ "${device}" ]; };

          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.yubioath-flutter}/bin/yubioath-flutter";
          };
        };
      };
    };
  };

  programs = {
    gpg = {
      scdaemonSettings = {
        disable-ccid = true;
        reader-port = "Yubico Yubi";
        pcsc-driver = "${
            pkgs.lib.makeLibraryPath (with pkgs; [ pcscliteWithPolkit ])
          }/libpcsclite.so";
      };
    };
  };
}
