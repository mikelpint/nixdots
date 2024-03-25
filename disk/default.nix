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
  luks = if luks == "" then
    true
  else if luks == "true" then
    true
  else if luks == "false" then
    false
  else
    luks;
  luks = if luks == true then "crypto" else luks;
  luks = assert luks == false || (builtins.isString luks
    && builtins.match "(w|d|+|_|.)(w|d|+|_|.|-)*" != null);
    luks;

  perc = "0*((dd)(.d+)?|100)%";
  size = "(d+)(.d+)?(k|M|G|T|P)";

  swap = if swap == "" then
    true
  else if swap == "true" then
    true
  else if swap == "false" then
    false
  else
    swap;
  swap = assert swap == true || swap == false || (builtins.isString swap
    && !(builtins.match perc swap == null && builtins.match size == null));
    swap;

  meminfo = builtins.readFile "/proc/meminfo";
  memTotalLine = builtins.head
    (builtins.filter (line: builtins.hasPrefix "MemTotal:" line)
      (builtins.split "\n" meminfo));
  memTotal =
    builtins.replaceStrings [ "MemTotal:" " kB" ] [ "" "" ] memTotalLine;
  memTotal = builtins.toNumber memTotal;

  swap = if swap == false then
    false
  else if swap == true then
    if memTotal < 8 * 1024 * 1024 then memTotal else (memTotal / 2) + "kB"
  else if builtins.match perc swap then
    (memTotal * (builtins.toNumber (substring 0 - 1 swap) / 100)) + "kB"
  else
    swap;

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

      "/swap" = lib.mkIf (swap != false) {
        mountpoint = "/.swap";
        swap = { sweapfile = { size = swap; }; };
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

                content = if luks != false then {
                  type = "luks";
                  name = luks;

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
