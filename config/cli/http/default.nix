{ pkgs, ... }:

{
  environment = { systemPackages = with pkgs; [ wget curl httpie openssl ]; };
}
