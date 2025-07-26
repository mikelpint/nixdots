{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../cli/jq/home.nix ];

  home = {
    packages =
      with pkgs;
      [
        jd
        jc
        gron
        jless
      ]
      ++ (lib.optionals (config.programs.jq.enable or false) [ jq-lsp ]);
  };
}
