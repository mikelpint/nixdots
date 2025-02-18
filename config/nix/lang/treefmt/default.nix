{ pkgs, ... }: { environment = { systemPackages = with pkgs; [ treefmt ]; }; }
