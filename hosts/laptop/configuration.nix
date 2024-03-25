{
  imports = [ ./hardware/laptop ./hardware-configuration.nix ];

  networking = { hostname = "laptop"; };

  presets = {
    desktop = enabled;
    dev = enabled;
    gaming = disabled;
    music = enabled;
    rice = enabled;
    social = enabled;
    video = enabled;
  };

  systems = {
    laptop = {
      modules = with inputs;
        [
          (import ../../disks/default.nix {
            inherit lib;
            device = "/dev/nvme0n1";
            luks = true;
            swap = true;
          })
        ];
    };
  };
}
