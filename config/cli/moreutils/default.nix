{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ moreutils ];
  };
}
