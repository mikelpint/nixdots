{ pkgs, ... }:

{
  home = { packages = with pkgs; [ vscode gnome-keyring ]; };
}
