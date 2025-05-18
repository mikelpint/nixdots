{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      bc
    ];
  };
}
