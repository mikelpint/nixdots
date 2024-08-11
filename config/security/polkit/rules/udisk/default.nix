{ lib, ... }:

let
  group = "storage";
in
{
  security = {
    polkit = {
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          var YES = polkit.Result.YES;
          var permission = {
            "org.freedesktop.udisks.filesystem-mount": YES,
            "org.freedesktop.udisks.luks-unlock": YES,
            "org.freedesktop.udisks.drive-eject": YES,
            "org.freedesktop.udisks.drive-detach": YES,

            "org.freedesktop.udisks2.filesystem-mount": YES,
            "org.freedesktop.udisks2.encrypted-unlock": YES,
            "org.freedesktop.udisks2.eject-media": YES,
            "org.freedesktop.udisks2.power-off-drive": YES,

            "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
            "org.freedesktop.udisks2.filesystem-unmount-others": YES,
            "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
            "org.freedesktop.udisks2.encrypted-unlock-system": YES,
            "org.freedesktop.udisks2.eject-media-other-seat": YES,
            "org.freedesktop.udisks2.power-off-drive-other-seat": YES
          };

          if (subject.isInGroup("${group}")) {
            return permission[action.id];
          }
        });
      '';
    };
  };

  users = {
    groups = {
      "$group" = { };
    };
  };
}
