_: {
  services = {
    usbguard = {
      enable = true;

      dbus = { enable = true; };

      implicitPolicyTarget = "block";
    };
  };
}
