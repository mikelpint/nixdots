{
  lib,
  config,
  pkgs,
  ...
}:
let
  apparmor = config.security.apparmor.enable;
  ifapparmor = lib.mkIf apparmor;
in
{
  services = {
    dbus = {
      apparmor = ifapparmor "enabled";

      dbusPackage = pkgs.dbus;
      brokerPackage = pkgs.dbus-broker;
      implementation = lib.mkDefault (if apparmor then "dbus" else "broker"); # https://wiki.archlinux.org/title/D-Bus
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # https://wiki.archlinux.org/title/Iwd#Allow_any_user_to_read_status_information
      (writeTextFile {
        name = "iwd-allow-read";
        destination = "/etc/dbus-1/system.d/iwd-allow-read.conf";
        text = ''
          <!-- Allow any user to read iwd status information. Overrides some part
               of /usr/share/dbus-1/system.d/iwd-dbus.conf. -->

          <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
           "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>

            <policy context="default">
              <deny send_destination="net.connman.iwd"/>
              <allow send_destination="net.connman.iwd" send_interface="org.freedesktop.DBus.Properties" send_member="GetAll" />
              <allow send_destination="net.connman.iwd" send_interface="org.freedesktop.DBus.Properties" send_member="Get" />
              <allow send_destination="net.connman.iwd" send_interface="org.freedesktop.DBus.ObjectManager" send_member="GetManagedObjects" />
              <allow send_destination="net.connman.iwd" send_interface="net.connman.iwd.Device" send_member="RegisterSignalLevelAgent" />
              <allow send_destination="net.connman.iwd" send_interface="net.connman.iwd.Device" send_member="UnregisterSignalLevelAgent" />
            </policy>

          </busconfig>
        '';
      })
    ];
  };
}
