{ pkgs, config, ... }:

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
      curl = {
          executable = "${pkgs.curl}/bin/curl";
          profile = "${config.programs.firejail.package}/etc/firejail/curl.profile";
      };

      wget = {
          executable = "${pkgs.wget}/bin/wget";
          profile = "${config.programs.firejail.package}/etc/firejail/wget.profile";
      };

      wget2 = {
          executable = "${pkgs.wget2}/bin/wget2";
          profile = "${config.programs.firejail.package}/etc/firejail/wget2.profile";
      };
    };
  };
}
