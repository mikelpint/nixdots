{
  pkgs,
  config,
  user,
  lib,
  ...
}:
{
  hardware = {
    graphics = lib.mkIf (config.home-manager.users.${user}.programs.mangohud.enable or false) {
      extraPackages = with pkgs; [ mangohud ];
      extraPackages32 = with pkgs; [ mangohud ];
    };
  };
}
