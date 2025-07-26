{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      turbo-unwrapped
    ];
  };
}
