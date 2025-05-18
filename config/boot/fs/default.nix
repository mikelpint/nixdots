{ lib, ... }:
{
  imports = [ ./udf ];

  fileSystems = {
    "/" = {
      noCheck = lib.mkDefault true;
    };
  };
}
