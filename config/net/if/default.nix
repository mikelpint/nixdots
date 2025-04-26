{ lib, ... }:
{
  imports = [ ./tornet ];

  networking = {
    usePredictableInterfaceNames = lib.mkDefault true;
  };
}
