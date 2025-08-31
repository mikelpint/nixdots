{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ fq ];
  };
}
