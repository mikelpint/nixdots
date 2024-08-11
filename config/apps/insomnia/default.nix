{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ (pkgs.callPackage ../../../pkgs/insomnia { src = insomnia; }) ];
  };
}
