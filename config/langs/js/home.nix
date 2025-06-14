{ pkgs, home-manager, ... }:

{
  home = {
    packages = with pkgs; [
      deno

      graphviz

      nodePackages_latest.nodejs
      nodePackages_latest.pnpm

      nodePackages_latest.prisma

      tailwindcss_4
      tailwindcss-language-server

      turbo-unwrapped

      typescript
    ];

    sessionVariables = {
      PATH = "$PATH:$HOME/.npm-global:$HOME/.pnpm-global";
      PNPM_HOME = "$HOME/.pnpm-global";
    };

    activation = {
      npm-prefix = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
        run ${pkgs.nodePackages_latest.nodejs}/bin/npm set prefix $HOME/.npm-global
        run ${pkgs.nodePackages_latest.pnpm}/bin/pnpm set prefix $HOME/.pnpm-global
      '';
    };
  };
}
