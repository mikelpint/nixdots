{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ chkrootkit ];
  };
}
