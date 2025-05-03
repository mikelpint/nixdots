{ pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      wget
      wget2
      curl
      openssl
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        curl = {
          executable = "${lib.getBin pkgs.curl}/bin/curl";
          profile = "${pkgs.firejail}/etc/firejail/curl.profile";
        };

        wget = {
          executable = "${lib.getBin pkgs.wget}/bin/wget";
          profile = "${pkgs.firejail}/etc/firejail/wget.profile";
        };

        wget2 = {
          executable = "${lib.getBin pkgs.wget2}/bin/wget2";
          profile = "${pkgs.firejail}/etc/firejail/wget2.profile";
        };
      };
    };
  };
}
