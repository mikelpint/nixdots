{ lib, ... }: {
  services = {
    libinput = {
      enable = true;

      mouse = { accelProfile = lib.mkDefault "flat"; };
    };
  };
}
