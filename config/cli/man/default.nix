{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      linux-manual
      man-pages
      man-pages-posix
    ];
  };

  documentation = {
    enable = true;

    dev = {
      enable = lib.mkDefault true;
    };

    doc = {
      enable = true;
    };

    info = {
      enable = true;
    };

    man = {
      generateCaches = lib.mkDefault true;

      man-db = {
        enable = lib.mkDefault (!(config.documentation.man.mandoc.enable or false));
      };

      mandoc = {
        enable = lib.mkDefault false;
      };
    };
  };
}
