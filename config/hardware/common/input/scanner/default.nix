{ user, ... }:
{
  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
      };
    };
  };

  hardware = {
    sane = {
      enable = true;
    };
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [
          "scanner"
          "lp"
        ];
      };
    };
  };
}
