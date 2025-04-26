{ user, pkgs, osConfig, ... }:
let
  package = pkgs.wireshark-cli;
in {
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
      wireshark-cli = {
        executable = "${package}/bin/tshark";
        profile = "${osConfig.programs.firejail.package}/etc/firejail/tshark.profile";
      };

      wireshark-qt = {
        executable = "${pkgs.wireshark-qt}/bin/wireshark-qt";
        profile = "${osConfig.programs.firejail.package}/etc/firejail/wireshark-qt.profile";
      };
    };
  };
}
