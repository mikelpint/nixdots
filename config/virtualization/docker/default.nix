{ config, pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;

      rootless = {
        enable = false;
        setSocketVariable = config.virtualisation.docker.rootless.enable;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ docker-compose ];
  };
}
