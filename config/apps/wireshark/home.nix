{ pkgs, ... }:
let
  inherit (pkgs) wireshark-qt;
in
{
  home = {
    packages = [ wireshark-qt ];
  };
}
