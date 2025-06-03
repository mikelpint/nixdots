{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      pgcli
      pspg
    ];

    file = {
      ".psqlrc" = {
        text = ''
          \set QUIET 1
          \pset linestyle unicode
          \pset border 2
          \unset QUIET
        '';
      };
    };
  };

  xdg = {
    configFile = {
      "pgcli/config" = {
        text = ''
          [main]

          pager = ${pkgs.pspg}/bin/pspg --rr=2 --quit-if-one-screen --ignore-case --reprint-on-exit

          row_limit = 10000

          less_chatty = True

          prompt = '\H:\d> '

          keyring = False
        '';
      };
    };
  };
}
