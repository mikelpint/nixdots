{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ fbcat ];
  };
}
