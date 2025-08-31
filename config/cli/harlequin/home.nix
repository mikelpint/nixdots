{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ harlequin ];
  };
}
