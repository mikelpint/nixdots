{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      iredis
    ];
  };
}
