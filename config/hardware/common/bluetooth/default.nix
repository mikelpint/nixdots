{ lib, ... }:
{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = lib.mkDefault true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;

          PairableTimeout = 30;
          DiscoverableTimeout = 30;
          TemporaryTimeout = 0;
          MaxControllers = 1;
        };

        Policy = {
          AutoEnable = false;
          Privacy = "network/on";
        };
      };
    };
  };

  services = {
    blueman = {
      enable = true;
    };
  };
}
