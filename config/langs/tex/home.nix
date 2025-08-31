{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [
      texliveFull
      texlab
      inkscape
      bibiman
    ];
  };

  programs =
    lib.mkIf
      (
        let
          any = builtins.any (
            let
              match = builtins.match "^texlive.*$";
            in
            x: (match (if lib.attrsets.isDerivation x then lib.getName x else null) != null)
          );
        in
        any config.home.packages || any osConfig.environment.systemPackages
      )
      {
        zed-editor = {
          extensions = [ "latex" ];

          userSettings = {
            lsp = {
              texlab =
                let
                  find =
                    let
                      texlab = lib.getName pkgs.texlab;
                    in
                    x: (if lib.attrsets.isDerivation x then lib.getName x else null) == texlab;

                  texlab = lib.lists.findFirst find (lib.lists.findFirst find null
                    osConfig.environment.systemPackages
                  ) config.home.packages;
                in
                lib.mkIf (texlab != null) {
                  binary = {
                    path = "${lib.getBin texlab}/bin/texlab";
                  };

                  settings = {
                    texlab = {
                      build = {
                        onSave = false;
                      };
                    };
                  };
                };
            };
          };
        };
      };
}
