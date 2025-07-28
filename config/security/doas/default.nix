{
  user,
  lib,
  config,
  pkgs,
  ...
}:
{
  security = {
    sudo = lib.mkIf (config.security.doas.enable or false) {
      enable = false;
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

  environment = lib.mkIf (config.security.doas.enable or false) {
    systemPackages = with pkgs; [ doas-sudo-shim ];
  };
}
