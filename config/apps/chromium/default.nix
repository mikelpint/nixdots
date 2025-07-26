{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  programs = lib.mkIf false {
    chromium = {
      extraOpts = {
        "ExtensionManifestV2Availability" = 2;
      };
    };

    firejail = {
      wrappedBinaries = builtins.listToAttrs (
        let
          binExists = pkg: bin: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";

          extraArgs = lib.optional (
            (config.security.environment.memoryAllocator.provider or "libc") != "libc"
          ) "--blacklist=/etc/ld-nix.so.preload";
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
                        (config.home-manager.users.${user}.programs.chromium.enable or false)
                        && binExists (config.home-manager.users.${user}.programs.chromium.package or pkgs.chromium) name
                      )
                    then
                      config.home-manager.users.${user}.programs.chromium.package or pkgs.chromium
                    else if
                      (
                        (config.programs.chromium.enable or false)
                        && binExists (config.programs.chromium.package or pkgs.chromium) name
                      )
                    then
                      config.programs.chromium.package or pkgs.chromium
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
                  inherit extraArgs;
                };
            }) (lib.lists.toList bin)
          )
          [
            {
              bin = "chromium";

              ps = with pkgs; [
                ungoogled-chromium
                chromium
              ];
            }

            {
              bin = "chromium-browser";

              ps = with pkgs; [
                ungoogled-chromium
                chromium
              ];
            }

            {
              bin = [
                "google-chrome"
                "google-chrome-stable"
                "google-chrome-beta"
                "google-chrome-unstable"
              ];

              ps = with pkgs; [ google-chrome ];
            }
          ]
      );
    };
  };

  security = lib.mkIf false {
    chromiumSuidSandbox = {
      enable = true;
    };
  };
}
