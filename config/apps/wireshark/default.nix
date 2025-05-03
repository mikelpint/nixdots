{
  user,
  pkgs,
  lib,
  ...
}:
let
  package = pkgs.wireshark-cli;
in
{
  programs = {
    wireshark = {
      enable = true;
      inherit package;

      dumpcap = {
        enable = true;
      };
      usbmon = {
        enable = true;
      };
    };
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "wireshark" ];
      };
    };

    groups = {
      wireshark = { };
    };
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        wireshark-cli = {
          executable = "${lib.getBin package}/bin/tshark";
          profile = "${pkgs.firejail}/etc/firejail/tshark.profile";
        };

        wireshark-qt = {
          executable = "${lib.getBin pkgs.wireshark-qt}/bin/wireshark-qt";
          profile = "${pkgs.firejail}/etc/firejail/wireshark-qt.profile";
        };
      };
    };
  };
}
