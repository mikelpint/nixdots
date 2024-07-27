{ config, pkgs, lib, ... }:

{
  imports =
    [ ./bootloader ./efi ./fs ./kernel ./plymouth ./systemd ./verbosity ];
}
