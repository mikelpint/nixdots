{ lib, ... }:
{
  imports = [
    ./nfs
    ./ntfs
    ./udf
  ];

  fileSystems = {
    "/" = {
      noCheck = lib.mkDefault true;
    };
  };
}
