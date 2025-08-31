{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ lnav ];
  };
}
