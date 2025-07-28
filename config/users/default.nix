{
  user,
  lib,
  config,
  pkgs,
  ...
}:
{
  users = {
    users = {
      root = {
        initialPassword = "";
      };

      "${user}" = {
        uid = lib.mkDefault 1000;

        description = lib.mkDefault "";
        isNormalUser = lib.mkDefault true;
        home = lib.mkDefault "/home/${user}";

        group = lib.mkDefault user;
        extraGroups = [ "users" ];

        hashedPassword = lib.mkDefault "";

        ignoreShellProgramCheck = lib.mkDefault true;
      };
    };

    groups = {
      "${user}" = {
        gid = lib.mkDefault config.users.users.${user}.uid;
      };
    }
    // (builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = lib.mkDefault { };
      }) config.users.users.${user}.extraGroups or [ ]
    ));

    mutableUsers = false;
    defaultUserShell = lib.mkDefault pkgs.bashInteractive;
  };

  imports = [ ./${user} ];
}
