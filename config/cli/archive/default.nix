{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
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
          executable = "${pkgs.p7zip}/bin/7z";
          profile = "${pkgs.firejail}/etc/firejail/7z.profile";
        };

        "7za" = {
          executable = "${pkgs.p7zip}/bin/7za";
          profile = "${pkgs.firejail}/etc/firejail/7za.profile";
        };

        "7zr" = {
          executable = "${pkgs.p7zip}/bin/7zr";
          profile = "${pkgs.firejail}/etc/firejail/7zr.profile";
        };

        unrar = {
          executable = "${pkgs.unrar}/bin/unrar";
          profile = "${pkgs.firejail}/etc/firejail/unrar.profile";
        };

        unzip = {
          executable = "${pkgs.unzip}/bin/unzip";
          profile = "${pkgs.firejail}/etc/firejail/unzip.profile";
        };
      };
    };
  };
}
