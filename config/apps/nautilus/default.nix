{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  find =
    p: default: list:
    lib.lists.findFirst (
      let
        name = lib.getName p;
      in
      x: (if lib.attrsets.isDerivation x then lib.getName x else null) == name
    ) default list;

  nautilus =
    let
      p = pkgs.nautilus;
    in
    find p (find p null
      config.environment.systemPackages
    ) config.home-manager.users.${user}.home.packages;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        file-roller =
          let
            p = pkgs.file-roller;
            file-roller = find p (find p null
              config.environment.systemPackages
            ) config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (file-roller != null) {
            executable = "${lib.getBin file-roller}/bin/file-roller";
            profile = "${pkgs.firejail}/etc/firejail/file-roller.profile";
          };

        nautilus = lib.mkIf (nautilus != null) {
          executable = "${lib.getBin nautilus}/bin/nautilus";
          profile = "${pkgs.firejail}/etc/firejail/nautilus.profile";
        };

        sushi =
          let
            p = pkgs.sushi;
            sushi = find p (find p null
              config.environment.systemPackages
            ) config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (sushi != null) {
            executable = "${lib.getBin sushi}/bin/sushi";
            profile = "${pkgs.firejail}/etc/firejail/sushi.profile";
          };
      };
    };
  };

  environment = lib.mkIf (nautilus != null) {
    systemPackages = with pkgs; [
      libheif
      libheif.out
    ];

    pathsToLink = [ "share/thumbnailers" ];
  };
}
