{ lib, ... }: {
  imports = [ ./memtest86 ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";

        useOSProber = true;

        configurationLimit = 5;

        efiSupport = true;
        gfxmodeEfi = lib.mkDefault "auto";
        gfxpayloadEfi = "keep";

        catppuccin = {
          enable = true;
          flavor = "macchiato";
        };
      };
    };
  };
}
