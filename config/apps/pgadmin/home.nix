{ pkgs, ... }: { home = { packages = with pkgs; [ pgadmin4-desktopmode ]; }; }
