{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gping
    ];
  };
}
