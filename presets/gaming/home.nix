_: {
  imports = [ ../../config/apps/mangohud ../../config/apps/steam ];
  home = {
    packages = with pkgs;
      [
        (pkgs.callPackage ../../../pkgs/wine-discord-ipc-bridge {
          src = wine-discord-ipc-bridge;
        })
      ];
  };
}
