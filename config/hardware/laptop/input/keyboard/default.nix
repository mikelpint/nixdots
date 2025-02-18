{ lib, ... }: {
  console = { keyMap = lib.mkForce "es"; };

  services = {
    xserver = {
      xkb = lib.mkForce {
        variant = "";
        layout = "es";
      };
    };
  };
}
