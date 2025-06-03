{
  config,
  lib,
  user,
  pkgs,
  ...
}:
{
  programs = {
    adb = {
      enable = true;
    };
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = lib.mkIf config.programs.adb.enable [ "adbusers" ];
      };
    };
  };

  services = {
    udev = {
      packages = with pkgs; [ android-udev-rules ];
    };
  };
}
