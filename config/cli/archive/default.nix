{ pkgs, config, ... }:

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
      "7z" = {
          executable = "${pkgs.p7zip}/bin/7z";
          profile = "${config.programs.firejail.package}/etc/firejail/7z.profile";
      };

      "7za" = {
          executable = "${pkgs.p7zip}/bin/7za";
          profile = "${config.programs.firejail.package}/etc/firejail/7za.profile";
      };

      "7zr" = {
          executable = "${pkgs.p7zip}/bin/7zr";
          profile = "${config.programs.firejail.package}/etc/firejail/7zr.profile";
      };

      unrar = {
          executable = "${pkgs.unrar}/bin/unrar";
          profile = "${config.programs.firejail.package}/etc/firejail/unrar.profile";
      };

      unzip = {
          executable = "${pkgs.unzip}/bin/unzip";
          profile = "${config.programs.firejail.package}/etc/firejail/unzip.profile";
      };
    };
  };
}
