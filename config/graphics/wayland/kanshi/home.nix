{ pkgs, config, ... }:
{
  services = {
    kanshi = {
      enable = true;
      package = pkgs.kanshi;
      systemdTarget = config.wayland.systemd.target;

      settings = { };
      profiles = { };
    };
  };
}
