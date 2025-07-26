{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
let
  any =
    _pkg:
    builtins.any (
      x:
      let
        p = lib.getName p;
      in
      (if lib.attrsets.isDerivation x then lib.getName x else null) == p
    );

  hasPostgres =
    let
      postgres = any pkgs.postgresql;
    in
    (postgres config.home.packages)
    || (postgres osConfig.environment.systemPackages)
    || (osConfig.services.postgresql.enable or false);
in
{
  home = {
    packages = with pkgs; [
      pgcli
      pspg
      postgres-lsp
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

  programs = {
    zed-editor = lib.mkIf false {
      extensions = lib.optional (
        (
          let
            lsp = any pkgs.postgres-lsp;
          in
          (lsp config.home.packages) || (lsp osConfig.environment.systemPackages)
        )
        || hasPostgres
      ) "postgres-language-server";
    };

    zsh = {
      oh-my-zsh = lib.mkIf false {
        plugins = lib.optional hasPostgres "postgres";
      };
    };
  };

  xdg = {
    configFile = {
      "pgcli/config" = {
        text = ''
          [main]

          pager = ${lib.getBin pkgs.pspg}/bin/pspg --rr=2 --quit-if-one-screen --ignore-case --reprint-on-exit

          row_limit = 10000

          less_chatty = True

          prompt = '\H:\d> '

          keyring = False
        '';
      };
    };
  };
}
