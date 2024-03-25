{ pkgs, ... }:

{
  home = { packages = with pkgs; [ traceroute wl-clipboard xclip ]; };
}
