{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      procs
    ];
  };
}
