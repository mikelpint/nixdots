{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ htmlq ];
  };

  programs = {
    zed-editor = {
      extensions = [ "html" ];
    };
  };
}
