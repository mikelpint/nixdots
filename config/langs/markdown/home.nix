{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      glow

      marksman

      mermaid-cli
      mermaid-filter
    ];
  };

  programs = {
    zed-editor = {
      extensions = lib.optionals (
        (lib.lists.count (
          x:
          (if lib.attrsets.isDerivation x then lib.getName x else null)
          == (lib.getName pkgs.nodePackages.mermaid-cli)
        ) config.home.packages) > 0
      ) [ "mermaid" ];
    };
  };
}
