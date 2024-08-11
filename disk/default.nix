# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk/default.nix --arg device '"/dev/nvme0n1"'

# - Partition 1: 1MB, emtpy
# - Partition 2: 512MB, ESP
# - Partition 3: 100%, BTRFS (+ LUKS if enabled, not tested)
#   - Subvolumes:
#     - /home
#     - /nix
#     - /var/lib
#     - /var/log
#     - /tmp
# - Partition 4: arbitrary size (not tested) or 50% of installed memory if unspecified, swap (optional)

{
  lib,
  device ? throw "No disk device.",
  luks ? false,
  swap ? false,
  mountOptions ? [
    "compress=zstd:3"
    "noatime"
    "ssd"
    "space_cache=v2"
    "commit=120"
  ],
  ...
}:

let
  luksName =
    if luks == true || luks == "" || luks == "true" then
      "crypto"
    else if luks == "false" then
      false
    else if luks == false then
      luks
    else
      (
        assert builtins.isString luks && builtins.match "(w|d|+|_|.)(w|d|+|_|.|-)*" != null;
        luks
      );

  perc = "0*((dd)(.d+)?|100)%";
  size = "(d+)(.d+)?(k|M|G|T|P)";

  meminfo = builtins.readFile "/proc/meminfo";
  memTotalLine = builtins.head (
    (builtins.filter (line: lib.strings.hasPrefix "MemTotal:" line)) (
      lib.strings.splitString "\n" meminfo
    )
  );
  memTotal = lib.strings.toInt (
    builtins.replaceStrings
      [
        "MemTotal:"
        " kB"
      ]
      [
        ""
        ""
      ]
      memTotalLine
  );

  swapSize =
    if swap == false || swap == "false" then
      false
    else if swap == true || swap == "" || swap == "true" then
      (builtins.toString (if memTotal < 8 * 1024 * 1024 then memTotal else (memTotal / 2))) + "K"
    else
      (
        assert
          swap == true
          || swap == false
          || (builtins.isString swap && !(builtins.match perc swap == null && builtins.match size == null));
        if builtins.match perc swap then
          (builtins.toString (memTotal * (lib.strings.toInt (builtins.substring 0 - 1 swap) / 100))) + "K"
        else
          swap
      );

  content = {
    type = "btrfs";
    mountpoint = "/";
    inherit mountOptions;
    extraArgs = [ "-f" ];

    subvolumes = {
      "/home" = {
        inherit mountOptions;
        mountpoint = "/home";
      };

      "/nix" = {
        inherit mountOptions;
        mountpoint = "/nix";
      };

      "/var/lib" = {
        inherit mountOptions;
        mountpoint = "/var/lib";
      };

      "/var/log" = {
        inherit mountOptions;
        mountpoint = "/var/log";
      };

      "/tmp" = {
        inherit mountOptions;
        mountpoint = "/tmp";
      };
    };
  };
in
{
  disko = {
    enableConfig = false;

    devices = {
      disk = {
        main = {
          device = builtins.toPath device;
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

                content =
                  if luksName != false then
                    {
                      type = "luks";
                      name = luksName;

                      settings = {
                        allowDiscards = true;
                        keyFile = "../../secrets/luks/root.key";
                      };

                      additionalKeyfiles = builtins.filter (file: builtins.hasSuffix ".key" file && file != "root.key") (
                        builtins.readDir "../../secrets/luks"
                      );

                      inherit content;
                    }

                  else
                    content;
              };

              swap = lib.mkIf (swapSize != false) {
                size = swapSize;

                content = {
                  type = "swap";
                  discardPolicy = "both";
                  resumeDevice = true;
                };
              };
            };
          };
        };
      };
    };
  };
}
