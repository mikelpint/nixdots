{
  pkgs,
  osConfig,
  lib,
  ...
}:
{
  programs = lib.mkIf false {
    zed-editor =
      let
        find = lib.lists.findFirst (
          let
            nixd = lib.getName pkgs.nixd;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == nixd
        );
        nixd = find null osConfig.environment.systemPackages;
        # nixd = find (find null osConfig.environment.systemPackages) config.home.packages;
      in
      lib.mkIf (nixd != null) {
        extraPackages = [ nixd ];

        userSettings = {
          languages = {
            Nix = {
              language_servers = [
                "nixd"
                "!nil"
              ];
            };
          };

          lsp = {
            nixd = {
              binary = {
                path = "${lib.getBin nixd}/bin/nixd";
              };

              settings = {
                autoArchive = true;
              };
            };
          };
        };
      };
  };
}
