{ pkgs, ... }:

{
  environment = { systemPackages = with pkgs; [ wget curl openssl ]; };
}
