{
  pkgs,
  lib,
  self,
  user,
  ...
}:
let
  package = pkgs.wrapFirefox (pkgs."firefox-unwrapped".override {
    # pipewireSupport = true;
  }) { };
in
{
  age = {
    secrets = {
      kagi-private-token = {
        owner = user;
        rekeyFile = "${self}/secrets/kagi-private-token.age";
      };
    };
  };

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
