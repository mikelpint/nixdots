# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk/default.nix --arg device '"/dev/nvme0n1"'

{ lib, device ? throw "No disk device.", luks ? false, swap ? false
, mountOptions ? [
  "compress=zstd:3"
  "noatime"
  "ssd"
  "space_cache=v2"
  "commit=120"
], ... }:

let
  luksName = if luks == true || luks == "" || luks == "true" then
    "crypto"
  else if luks == "false" then
    false
  else if luks == false then
    luks
  else
    (assert builtins.isString luks && builtins.match "(w|d|+|_|.)(w|d|+|_|.|-)*"
      != null;
      luks);

  perc = "0*((dd)(.d+)?|100)%";
  size = "(d+)(.d+)?(k|M|G|T|P)";

  meminfo = builtins.readFile "/proc/meminfo";
  memTotalLine = builtins.head
    (builtins.filter (line: builtins.hasPrefix "MemTotal:" line)
      (builtins.split "\n" meminfo));
  memTotal = builtins.toNumber
    (builtins.replaceStrings [ "MemTotal:" " kB" ] [ "" "" ] memTotalLine);

  swapSize = if swap == false || swap == "false" then
    false
  else if swap == true || swap == "" || swap == "true" then
    if memTotal < 8 * 1024 * 1024 then memTotal else (memTotal / 2) + "kB"
  else
    (assert swap == true || swap == false || (builtins.isString swap
      && !(builtins.match perc swap == null && builtins.match size == null));
      if builtins.match perc swap then
        (memTotal * (builtins.toNumber (builtins.substring 0 - 1 swap) / 100))
        + "kB"
      else
        swap);

  content = {
    type = "filesystem";
    format = "btrfs";
    mountpoint = "/";
    extraArgs = [ "-f" ];

    subvolumes = {
      "/root" = {
        inherit mountOptions;
        mountpoint = "/";
      };

      "/home" = {
        inherit mountOptions;
        mountpoint = "/home";
      };

      "/nix" = {
        inherit mountOptions;
        mountpoint = "/nix";
      };

      "/var" = {
        inherit mountOptions;
        mountpoint = "/var";
      };

      "/tmp" = {
        inherit mountOptions;
        mountpoint = "/tmp";
      };

      "/swap" = lib.mkIf (swapSize != false) {
        mountpoint = "/.swap";
        swap = { swapfile = { size = swapSize; }; };
      };
    };
  };
in {
  disko = {
    enableConfig = false;

    devices = {
      disk = {
        main = {
          inherit device;
          type = "disk";

          content = {
            type = "gpt";

            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };

              esp = {
                priority = 1;

                name = "ESP";
                size = "512M";
                type = "EF00";

                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "defaults" ];
                };
              };

              root = {
                name = "nixos";
                size = "100%";

                content = if luksName != false then {
                  type = "luks";
                  name = luksName;

                  settings = {
                    allowDiscards = true;
                    keyFile = "../../secrets/luks/root.key";
                  };

                  additionalKeyfiles = builtins.filter
                    (file: builtins.hasSuffix ".key" file && file != "root.key")
                    (builtins.readDir "../../secrets/luks");

                  inherit content;
                }

                else
                  content;
              };
            };
          };
        };
      };
    };
  };
}
