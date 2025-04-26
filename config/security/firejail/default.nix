{pkgs, ...}: {
  programs = {
    firejail = {
      enable = true;
      package = pkgs.firejail;
    };
  };
}
