{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    firejail = {
      enable = true;
    };
  };

  security = lib.mkIf config.programs.firejail.enable {
    apparmor = {
      policies = {
        firejail-default = {
          profile =
            # lib.replaceStrings [ "#include <local/" ] [ "#include <${pkgs.firejail}/etc/apparmor.d/local/" ]
            #   (
            #     lib.replaceStrings
            #       [ "#include <abstractions/" ]
            #       [ "#include <${pkgs.firejail}/etc/apparmor.d/abstractions/" ]
            #       (builtins.readFile "${pkgs.firejail}/etc/apparmor.d/firejail-default")
            #   )
            lib.replaceStrings [ "#include <local/firejail-default>" ] [ "" ] (
              builtins.readFile "${pkgs.firejail}/etc/apparmor.d/firejail-default"
            );
          state = "enforce";
        };
      };
    };
  };
}
