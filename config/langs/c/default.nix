{ pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      (lib.hiPrio gcc)
      # tinycc

      cmake
      gnumake
      gnupatch

      libclang
      (lib.hiPrio clang-tools)
    ];
  };
}
