{
  config,
  lib,
  user,
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
}
