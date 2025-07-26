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
            nil = lib.getName pkgs.nil;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == nil
        );
        nil = find null osConfig.environment.systemPackages;
        # nil = find (find null osConfig.environment.systemPackages) config.home.packages;
      in
      lib.mkIf (nil != null) {
        extraPackages = [ nil ];

        userSettings = {
          languages = {
            Nix = {
              language_servers = [
                "nil"
                "!nixd"
              ];
            };
          };

          lsp = {
            nil = {
              binary = {
                path = "${lib.getBin nil}/bin/nil";
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
