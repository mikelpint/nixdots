{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ fd ];
  };
}
