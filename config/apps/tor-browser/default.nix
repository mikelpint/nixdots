{ pkgs, lib, ... }:
let
  tor-browser = pkgs.tor-browser-bundle-bin;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        tor-browser = {
          executable = "${lib.getBin tor-browser}/bin/tor-browser";
          profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
        };
      };
    };
  };
}
