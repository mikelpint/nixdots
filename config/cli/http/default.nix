{ pkgs, ... }:

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
          executable = "${pkgs.curl}/bin/curl";
          profile = "${pkgs.firejail}/etc/firejail/curl.profile";
        };

        wget = {
          executable = "${pkgs.wget}/bin/wget";
          profile = "${pkgs.firejail}/etc/firejail/wget.profile";
        };

        wget2 = {
          executable = "${pkgs.wget2}/bin/wget2";
          profile = "${pkgs.firejail}/etc/firejail/wget2.profile";
        };
      };
    };
  };
}
