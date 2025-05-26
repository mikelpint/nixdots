{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ duf ];

    shellAliases = {
      df = "duf";
    };
  };
}
