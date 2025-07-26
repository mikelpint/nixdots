{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ widle ];
  };
}
