{ pkgs, ... }:
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
          executable = "${package}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
      };
    };
  };
}
