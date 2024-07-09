{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      deno
      nodejs
      typescript
      tailwindcss
      nodePackages.npm
    ];
  };
}
