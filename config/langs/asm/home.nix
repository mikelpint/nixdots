{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nasm
      fasm

      ghidra
      ghidra-extensions.findcrypt
      ghidra-extensions.ghidra-delinker-extension
      ghidra-extensions.gnudisassembler
      ghidra-extensions.wasm
    ];
  };
}
