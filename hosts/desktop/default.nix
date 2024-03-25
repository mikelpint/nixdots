{
  imports = [ ./hardware/desktop ./hardware-configuration.nix ];

  networking = { hostname = "desktop"; };

  presets = {
    desktop = enabled;
    dev = enabled;
    gaming = enabled;
    music = enabled;
    rice = enabled;
    social = enabled;
    video = enabled;
  };

  systems = {
    desktop = {
      modules = with inputs;
        [
          (import ../../disks/default.nix {
            inherit lib;
            device = "/dev/nvme0n1";
          })
        ];
    };
  };
}
