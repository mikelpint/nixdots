{
  pkgs,
  inputs,
  user,
  ...
}:
{
  imports = [ ./gamescope/home.nix ];

  programs = {
    mangohud = {
      settingsPerApplication = {
        steam = {
          no_display = true;
        };
      };
    };
  };

  home = {
    packages =
      with pkgs;
      with inputs.nix-gaming.packages.${pkgs.system};
      [
        steam-run
        steam-tui
        steamcmd
        steamguard-cli

        protonup
        # wine-ge
        # wine-discord-ipc-bridge
      ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytools.d";
    };
  };
}
