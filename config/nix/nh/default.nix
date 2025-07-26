{ pkgs, ... }:
{
  programs = {
    nh = {
      enable = true;
      package = pkgs.nh;

      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
