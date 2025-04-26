{ pkgs, ... }:
{
  services = {
    printing = {
      drivers = with pkgs; [ hplipWithPlugin ];
    };
  };
}
