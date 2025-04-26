{ pkgs, ... }:
{
  hardware = {
    graphics = {
      extraPackages = with pkgs; [ mangohud ];
      extraPackages32 = with pkgs; [ mangohud ];
    };
  };
}
