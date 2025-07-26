{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
    ];
  };
}
