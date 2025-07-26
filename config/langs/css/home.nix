{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      sass

      nodePackages_latest.less

      tailwindcss_4
      tailwindcss-language-server
    ];
  };

  programs =
    lib.mkIf
      (builtins.any (
        x:
        builtins.match "^${(lib.getName pkgs.tailwindcss)}(_[3-4]?)?$" (
          if lib.attrsets.isDerivation x then lib.getName x else null
        ) != null
      ) config.home.packages)
      {
        zed-editor = {
          extensions = [ "tailwindcss" ];

          userSettings = {
            lsp = {
              tailwindcss-language-server = {
                settings = {
                  classAttributes = [
                    "class"
                    "className"
                    "ngClass"
                    "styles"
                  ];
                };
              };
            };
          };
        };
      };
}
