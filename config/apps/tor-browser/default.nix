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
      wrappedBinaries = {
        tor-browser =
          let
            find = lib.lists.findFirst (
              let
                tor-browser-bundle-bin = lib.getName pkgs.tor-browser-bundle-bin;
                tor-browser = lib.getName pkgs.tor-browser;
              in
              x:
              let
                name = if lib.attrsets.isDerivation x then lib.getName x else null;
              in
              ((name == tor-browser-bundle-bin) || (name == tor-browser))
              && (builtins.pathExists "${lib.getBin x}/bin/tor-browser")
            );

            tor-browser =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (tor-browser != null) {
            executable = "${lib.getBin tor-browser}/bin/tor-browser";
            profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
          };
      };
    };
  };
}
