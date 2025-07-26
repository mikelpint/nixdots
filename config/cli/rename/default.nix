{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ rename ];
  };
}
