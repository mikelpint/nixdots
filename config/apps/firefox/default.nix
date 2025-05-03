{ pkgs, lib, ... }:
let
  package = pkgs.wrapFirefox (pkgs."firefox-unwrapped".override {
    # pipewireSupport = true;
  }) { };
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        firefox = {
          executable = "${lib.getBin package}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
      };
    };
  };
}
