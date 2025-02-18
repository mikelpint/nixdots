{ lib, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        memtest86 = {
          enable = lib.mkDefault true;
          sortKey = lib.mkDefault "o_memtest86";
        };
      };
    };
  };
}
