{ lib, ... }:
{
  security = {
    virtualisation = {
      flushL1DataCache = lib.mkDefault "cond";
    };
  };
}
