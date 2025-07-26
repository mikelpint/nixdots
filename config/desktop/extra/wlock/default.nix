{ pkgs, ... }:
{
  services = {
    widle = {
      enable = true;
      package = pkgs.wlock;
    };
  };
}
