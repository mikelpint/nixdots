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
      wrappedBinaries = builtins.listToAttrs (
        let
          binExists = pkg: bin: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";
        in
        builtins.flatMap
          (
            { bin, ps }:
            builtins.map (name: {
              inherit name;
              value =
                let
                  pkg =
                    if
                      (
                        (config.home-manager.users.${user}.programs.nixcord.enable or false)
                        && binExists (config.home-manager.users.${user}.programs.nixcord.discord.package or pkgs.discord
                        ) name
                      )
                    then
                      config.home-manager.users.${user}.programs.nixcord.discord.package or pkgs.discord
                    else
                      lib.lists.findFirst (
                        pkg:
                        let
                          name = lib.getName pkg;
                          pred =
                            x: ((if lib.attrsets.isDerivation x then lib.getName x else null) == name) && binExists x name;
                        in
                        (lib.lists.findFirst pred (lib.lists.findFirst pred null
                          config.environment.systemPackages
                        ) config.home-manager.users.${user}.home.packages) != null
                      ) null ps;
                in
                lib.mkIf (pkg != null) {
                  executable = "${lib.getBin pkg}/bin/${name}";
                  profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
                };
            }) (lib.lists.toList bin)
          )
          [
            {
              bin = "Discord";

              ps = with pkgs; [
                discord
                discord
              ];
            }

            {
              bin = "DiscordPTB";

              ps = with pkgs; [
                discord-ptb
              ];
            }

            {
              bin = "DiscordCanary";

              ps = with pkgs; [
                discord-canary
              ];
            }
          ]
      );
    };
  };
}
