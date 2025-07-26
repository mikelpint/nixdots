{ pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      atool
      libarchive
      p7zip
      unzip
      unrar
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        "7z" = {
          executable = "${lib.getBin pkgs.p7zip}/bin/7z";
          profile = "${pkgs.firejail}/etc/firejail/7z.profile";
        };

        "7za" = {
          executable = "${lib.getBin pkgs.p7zip}/bin/7za";
          profile = "${pkgs.firejail}/etc/firejail/7za.profile";
        };

        "7zr" = {
          executable = "${lib.getBin pkgs.p7zip}/bin/7zr";
          profile = "${pkgs.firejail}/etc/firejail/7zr.profile";
        };

        "atool" = {
          executable = "${lib.getBin pkgs.atool}/bin/atool";
          profile = "${pkgs.firejail}/etc/firejail/atool.profile";
        };

        unrar = {
          executable = "${lib.getBin pkgs.unrar}/bin/unrar";
          profile = "${pkgs.firejail}/etc/firejail/unrar.profile";
        };

        unzip = {
          executable = "${lib.getBin pkgs.unzip}/bin/unzip";
          profile = "${pkgs.firejail}/etc/firejail/unzip.profile";
        };
      };
    };
  };
}
