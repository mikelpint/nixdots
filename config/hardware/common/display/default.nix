{
  lib,
  config,
  user,
  ...
}:
{
  hardware = {
    i2c = {
      enable = lib.mkDefault true;
    };
  };

  boot = lib.mkIf (config.hardware.i2c.enable or false) {
    kernelModules = [ "i2c-dev" ];
  };

  users = lib.mkIf (config.hardware.i2c.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [ "i2c" ];
      };
    };
  };
}
