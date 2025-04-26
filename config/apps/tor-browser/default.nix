{ pkgs, ... }:
let
  tor-browser = pkgs.tor-browser-bundle-bin;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        tor-browser = {
          executable = "${tor-browser}/bin/tor-browser";
          profile = "${pkgs.firejail}/etc/firejail/tor-browser.profile";
        };
      };
    };
  };
}
