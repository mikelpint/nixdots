{ pkgs, ... }:
{
  powerManagement = {
    powertop = {
      enable = false;
    };
  };

  environment = {
    systemPackages = with pkgs; [ powertop ];
  };
}
