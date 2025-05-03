{ lib, ... }:
{
  networking = {
    nameservers = lib.mkMerge [ (lib.mkAfter [ "192.168.1.1" ]) ];
  };
}
