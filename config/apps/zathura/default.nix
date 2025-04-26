{config, pkgs, ...}: {
  programs = {
    firejail = {
      zathura = {
        executable = "${pkgs.zathura}/bin/zathura";
        profile = "${config.programs.firejail.package}/etc/firejail/gimp.profile";
      };
    };
  };
}
