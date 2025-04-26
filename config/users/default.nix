{ user, ... }:
{
  users = {
    users = {
      root = {
        initialPassword = "";
      };
    };

    mutableUsers = false;
  };

  imports = [ ./${user} ];
}
