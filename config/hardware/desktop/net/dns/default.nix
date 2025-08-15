{ lib, ... }:
{
  networking = {
    nameservers = lib.mkMerge [
      (lib.mkBefore [
        "1.1.1.1"
        "1.0.0.1"
      ])

      (lib.mkAfter [ "192.168.1.1" ])
    ];
  };
}
