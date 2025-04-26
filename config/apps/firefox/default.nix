{ pkgs, config, ... }:
let
  package = pkgs.wrapFirefox (pkgs."firefox-unwrapped".override {
    # pipewireSupport = true;
  }) { };
in
{
  firejail = {
    firefox = {
      executable = "${package}/bin/firefox";
      profile = "${config.programs.firejail.package}/etc/firejail/firefox.profile";
    };
  };
}
