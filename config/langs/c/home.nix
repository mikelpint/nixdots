{ pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      (lib.hiPrio gcc)
      gdb
      tinycc

      cmake
      gnumake
      gnupatch

      libclang
      (lib.hiPrio clang-tools)
      llvm
      lldb

      valgrind
    ];
  };
}
