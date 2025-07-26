{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  programs = {
    firejail = {
      wrappedBinaries =
        let
          find =
            ps: default: list:
            lib.lists.findFirst (
              p:
              lib.lists.findFirst (
                let
                  name = lib.getName p;
                in
                x: ((if lib.attrsets.isDerivation x then lib.getName x else null) == name)
              ) default list
            ) default ps;
        in
        {
          minecraft-launcher =
            let
              ps = with pkgs; [ minecraft ];
              minecraft-launcher = find ps (find ps null
                config.environment.systemPackages
              ) config.home-manager.users.${user}.home.packages;
            in
            lib.mkIf (minecraft-launcher != null) {
              executable = "${lib.getBin minecraft-launcher}/bin/minecraft-launcher";
              profile = "${pkgs.firejail}/etc/firejail/minecraft-launcher.profile";
            };

          prismlauncher =
            let
              ps = with pkgs; [
                prismlauncher-unwrapped
                prismlauncher
                prismlauncher-qt5-unwrapped
                prismlauncher-qt5
              ];
              prismlauncher = find ps (find ps null
                config.environment.systemPackages
              ) config.home-manager.users.${user}.home.packages;
            in
            lib.mkIf (prismlauncher != null) {
              executable = "${lib.getBin prismlauncher}/bin/prismlauncher";
              profile = "${pkgs.firejail}/etc/firejail/prismlauncher.profile";
            };
        };
    };
  };
}
