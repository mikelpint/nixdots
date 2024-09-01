{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      deno
      nodejs
      nodePackages.npm
      pnpm
      tailwindcss
      turbo-unwrapped
      typescript
    ];
  };
}
