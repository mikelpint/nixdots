{ pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      (lib.hiPrio gcc)
      gdb
      python3Packages.pygments

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

    file = {
      # https://github.com/cyrus-and/gdb-dashboard/blob/616ed5100d3588bb70e3b86737ac0609ce0635cc/.gdbinit
      ".gdbinit" = {
        source = ./.gdbinit;
      };
    };
  };
}
