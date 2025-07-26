{ inputs, pkgs, ... }:
{
  environment = {
    systemPackages = [ inputs.manix.packages.${pkgs.system}.manix ];
  };
}
