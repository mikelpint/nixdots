{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      gcc
      clang
      tinycc

      cmake
      gnumake
      gnupatch

      clangd

      clang-tools
    ];
  };
}
