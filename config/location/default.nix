{ lib, pkgs, ... }:
{
  location = {
    provider = "geoclue2";
  };

  services = {
    geoclue2 = {
      enable = lib.mkDefault true;
      package = pkgs.geoclue2;
    };
  };
}
