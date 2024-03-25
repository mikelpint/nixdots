{
  imports = [ ./hardware-configuration.nix ];

  networking = { hostname = "test"; };

  presets = {
    desktop = enabled;
    dev = enabled;
    gaming = enabled;
    music = enabled;
    rice = enabled;
    social = enabled;
    video = enabled;
  };

  test = {
    modules = with inputs;
      [
        (import ../../disks/default.nix {
          inherit lib;
          device = "/dev/vda";
        })
      ];
  };
}
