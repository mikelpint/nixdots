{ pkgs, lib, ... }:
{
  package = pkgs.treefmt;

  projectRootFile = "flake.nix";

  programs = {
    deadnix = {
      enable = true;
    };

    statix = {
      enable = true;
    };

    nixfmt = {
      enable = true;
    };

    yamlfmt = {
      enable = true;
    };

    shfmt = {
      enable = true;
    };

    shellcheck = {
      enable = false;
    };

    prettier = {
      enable = true;
    };
  };

  settings = {
    global = {
      excludes = [
        "*.age"
        "*.png"
        "*.gif"
        "*.pub"
        "*.asc"
        "*.bin"
        "*.conf"
        "*.lang"
      ];
    };

    formatter = {
      nixfmt = {
        command = lib.mkForce pkgs.nixfmt-rfc-style;
        includes = [ "*.nix" ];
      };

      pretter = {
        command = pkgs.nodePackages.prettier;
        includes = [ "*.json" ];
      };
    };
  };
}
