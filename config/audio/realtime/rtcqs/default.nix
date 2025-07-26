{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ rtcqs ];
  };
}
