{
  user,
  lib,
  config,
  ...
}:
{
  security = {
    sudo = {
      enable = !config.security.doas.enable;
    };

    doas = {
      enable = lib.mkDefault true;
      extraRules = [
        {
          noPass = true;
          keepEnv = true;

          users = [ user ];
        }
      ];
    };
  };

  environment = {
    shellAliases = {
      sudo = "doas";
    };
  };
}
