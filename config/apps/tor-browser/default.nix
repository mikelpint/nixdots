{ pkgs, config, ... }:
let
  tor-browser = pkgs.tor-tor-browser-bundle-bin;
in
{
  programs = {
    firejail = {
      tor-browser = {
        executable = "${tor-browser}/bin/tor-browser";
        profile = "${config.programs.firejail.package}/etc/firejail/tor-browser.profile";
      };
    };
  };
}
