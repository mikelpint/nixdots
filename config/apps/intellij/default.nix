{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; with jetbrains; [ idea-ultimate clion ];
  };
}
