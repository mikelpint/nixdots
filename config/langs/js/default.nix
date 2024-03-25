{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      deno
      nodejs
      typescript
      tailwindcss
      nodePackages.npm
    ];
  };
}
