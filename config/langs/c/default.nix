{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      gcc
      clang
      tinycc

      cmake
      gnumake
      gnupatch

      libclang
      clang-tools
    ];
  };
}
