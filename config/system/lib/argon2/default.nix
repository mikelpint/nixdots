{ pkgs, ... }: { environment = { systemPackages = with pkgs; [ libargon2 ]; }; }
