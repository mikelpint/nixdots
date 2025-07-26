{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ await ];
  };
}
