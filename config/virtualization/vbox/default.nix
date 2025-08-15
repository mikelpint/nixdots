{
  pkgs,
  user,
  config,
  lib,
  ...
}:
{
  virtualisation = {
    virtualbox = {
      host = {
        enable = lib.mkDefault true;
        package = pkgs.virtualbox;
        enableExtensionPack = lib.mkDefault (config.nixpkgs.config.allowUnfree or false);
        addNetworkInterface = lib.mkDefault (!(config.virtualisation.virtualbox.host.enableKvm or false));
        enableHardening = true;
        headless = lib.mkDefault false;
      };
    };
  };

  users = lib.mkIf (config.virtualisation.virtualbox.host.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [
          "vboxsf"
          "vboxusers"
        ];
      };
    };
  };
}
