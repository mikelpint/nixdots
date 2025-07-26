{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ yaml2json ];
  };

  programs = {
    zed-editor = {
      extensions = [ "yaml" ];
    };
  };
}
