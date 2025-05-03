{ lib, pkgs, ... }:
{
  location = {
    provider = "geoclue2";
  };

  services = {
    geoclue2 = {
      enable = lib.mkDefault false;
      package = pkgs.geoclue2;
    };
  };
}
