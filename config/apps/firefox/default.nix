{
  pkgs,
  lib,
  self,
  user,
  config,
  ...
}:
{
  age = {
    secrets = {
      kagi-private-token = {
        owner = user;
        rekeyFile = "${self}/secrets/kagi-private-token.age";
      };
    };
  };

  programs = {
    firejail = {
      wrappedBinaries = builtins.listToAttrs (
        let
          binExists = pkg: bin: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";
        in
        builtins.flatMap
          (
            {
              bin,
              ps,
              name ? null,
            }:
            builtins.map
              (name: {
                inherit name;
                value =
                  let
                    pkg =
                      if
                        (
                          (config.home-manager.users.${user}.programs.firefox.enable or false)
                          && binExists (config.home-manager.users.${user}.programs.firefox.package or pkgs.firefox) bin
                        )
                      then
                        config.home-manager.users.${user}.programs.firefox.package or pkgs.firefox
                      else if
                        (
                          (config.programs.firefox.enable or false)
                          && binExists (config.programs.firefox.package or pkgs.firefox) bin
                        )
                      then
                        config.programs.firefox.package or pkgs.firefox
                      else
                        lib.lists.findFirst (
                          pkg:
                          let
                            name = lib.getName pkg;
                            pred =
                              x: ((if lib.attrsets.isDerivation x then lib.getName x else null) == name) && binExists x bin;
                          in
                          (lib.lists.findFirst pred (lib.lists.findFirst pred null
                            config.environment.systemPackages
                          ) config.home-manager.users.${user}.home.packages) != null
                        ) null ps;
                  in
                  lib.mkIf (pkg != null) {
                    executable = "${lib.getBin pkg}/bin/${bin}";
                    profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
                  };
              })
              (
                builtins.map (bin: {
                  name = if name == null then bin else name;
                  inherit bin;
                }) (lib.lists.toList bin)
              )
          )
          [
            {
              bin = "firefox";

              ps = with pkgs; [
                firefox-unwrapped
                firefox
                firefox-bin-unwrapped
                firefox-bin
              ];
            }

            {
              name = "firefox-beta";
              bin = "firefox";

              ps = with pkgs; [
                firefox-beta-unwrapped
                firefox-beta
                firefox-beta-bin
              ];
            }

            {
              name = "firefox-developer-edition";
              bin = "firefox";

              ps = with pkgs; [
                firefox-devedition-unwrapped
                firefox-devedition
                firefox-devedition-bin
              ];
            }

            {
              name = "firefox-esr";
              bin = "firefox";

              ps = with pkgs; [
                firefox-esr-unwrapped
                firefox-esr
                firefox-esr-128-unwrapped
                firefox-esr-128
                firefox-esr-115-unwrapped
                firefox-esr-115
              ];
            }

            {
              name = "firefox-wayland";
              bin = "firefox";

              ps = with pkgs; [
                firefox-wayland
              ];
            }

            {
              bin = "librewolf";

              ps = with pkgs; [
                librewolf-wayland
                librewolf-unwrapped
                librewolf
                librewolf-bin-unwrapped
                librewolf-bin
              ];
            }
          ]
      );
    };
  };
}
