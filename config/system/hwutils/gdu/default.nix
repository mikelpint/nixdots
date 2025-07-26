{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ gdu ];
  };
}
