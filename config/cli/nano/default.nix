{ pkgs, ... }:
{
  programs = {
    nano = {
      enable = true;
      package = pkgs.nano;
    };
  };
}
