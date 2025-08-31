{ pkgs, ... }:
{
  systemd = {
    settings = {
      Manager = {
        DefaultTimeoutStopSec = "10s";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ isd ];
  };
}
