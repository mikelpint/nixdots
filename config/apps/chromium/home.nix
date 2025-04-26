{ pkgs, ... }:
let
  package = pkgs.chromium;
in
{
  programs = {
    chromium = {
      enable = true;
      inherit package;
    };
  };
}
