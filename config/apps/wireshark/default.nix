{
  user,
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark-cli;

      dumpcap = {
        enable = true;
      };

      usbmon = {
        enable = true;
      };
    };
  };

  users = lib.mkIf (config.programs.wireshark.enable or false) {
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
        wireshark-cli = lib.mkIf (config.programs.wireshark.enable or false) {
          executable = "${lib.getBin (config.programs.wireshark.package or pkgs.wireshark-cli)}/bin/tshark";
          profile = "${pkgs.firejail}/etc/firejail/tshark.profile";
        };

        wireshark-qt =
          let
            find = lib.lists.findFirst (
              let
                wireshark-qt = lib.getName pkgs.wireshark-qt;
              in
              x: (if lib.attrsets.isDerivation x then lib.getName x else null) == wireshark-qt
            );
            wireshark-qt =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (wireshark-qt != null) {
            executable = "${lib.getBin pkgs.wireshark-qt}/bin/wireshark-qt";
            profile = "${pkgs.firejail}/etc/firejail/wireshark-qt.profile";
          };
      };
    };
  };
}
