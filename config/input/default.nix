{ user, ... }:
{
  imports = [
    ./mouse
    ./touchpad
  ];

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "input" ];
      };
    };
  };
}
