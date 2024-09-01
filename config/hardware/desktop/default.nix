# My desktop PC
# https://es.pcpartpicker.com/user/mikelpint/saved/xY2M3C

{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  imports = [
    ../common
    ../common/output/printer/hp

    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./motherboard
    ./net
    ./output
    ./storage
  ];

  age = {
    rekey = {
      hostPubkey = lib.mkForce "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoCEm18/I9rzxUGQWqwixc2avNwaIl/jrr8hypEjwu+ZUPtcfcXpnd3GCvL2t9QuIWcD22WoqvXBX8Xb1Imc8upLOx1/ACMN2AX+xVH3q6DkGvctiMZ/87txsgEJYc7f1BSmSWSwY1u5G3PcA/wY3ioVWbYHsARbOGwu0/RKrBMzFC+vxu0rd8NHOHtegYIh629DcjB29ienlbqP6gJVTmXlsCJR2FnjQnTAnXekPx0xRyZHkvfO7EmXEs1o22v083ESn0bnhC0OoMJFgy1TvtVSqXo0iGZnCKC3CnIofdZsUfzAvfJb1XiBcS1IzuNEuSBdycMOQ6Q36qKO2u/NcIZDv/LVfZG5Bqv39YfXaOwibvFhga2ouRhiL+XNPs6213UgPmjo+nbAHMbw/KOypmGDllsxt2KQnEPxnzT4z2ZXybYSXSQnbwUJ1plgHwuL5Neno+8FQIV/iZgYoJtFY28W96/btG85fylff4yxKE/UD9ByHUZCbEENCfPoulotk=";
    };
  };
}
