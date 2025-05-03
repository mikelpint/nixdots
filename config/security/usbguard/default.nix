{
  config,
  user,
  lib,
  ...
}:
{
  services = {
    usbguard = {
      # enable = !config.boot.isContainer;
      enable = false;

      dbus = {
        enable = true;
      };

      implicitPolicyTarget = "block";
      insertedDevicePolicy = "apply-policy";
      presentDevicePolicy = "apply-policy";
      presentControllerPolicy = "keep";

      IPCAllowedGroups = [ "wheel" ];
      IPCAllowedUsers = [
        "root"
        user
      ];
    };
  };

  security = lib.mkIf config.services.usbguard.enable {
    polkit = {
      extraConfig = ''
        polkit.addRule(
            function(action, subject) {
                if (
                    (
                        action.id == "org.usbguard.Policy1.listRules" ||
                        action.id == "org.usbguard.Policy1.appendRule" ||
                        action.id == "org.usbguard.Policy1.removeRule" ||
                        action.id == "org.usbguard.Devices1.applyDevicePolicy" ||
                        action.id == "org.usbguard.Devices1.listDevices" ||
                        action.id == "org.usbguard1.getParameter" ||
                        action.id == "org.usbguard1.setParameter"
                    ) &&
                    (
                        subject.active == true &&
                        subject.local == true &&
                    (
                    ${(lib.lists.foldr (a: b: "${a} ||\n${b}") "false") (
                      map (group: "subject.isInGroup(\"${group}\")") config.services.usbguard.IPCAllowedGroups
                    )}
                    )
                ) { return polkit.Result.YES; }
            }
        );
      '';
    };
  };
}
