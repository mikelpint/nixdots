{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ initool ];
  };

  programs = {
    zed-editor = {
      extensions = [ "ini" ];
    };
  };
}
