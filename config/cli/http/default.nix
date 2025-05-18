{ pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      aria2
      curl
      openssl
      wget
      wget2
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        aria2 = {
          executable = "${lib.getBin pkgs.aria2}/bin/aria2";
          profile = "${pkgs.firejail}/etc/firejail/aria2c.profile";
        };

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
