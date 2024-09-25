# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk/laptop.nix --arg device '"/dev/nvme0n1"'

# - Empty, 1 MB
# - Partition 2: 1 GB, ESP
# - Partition 3: 100%, LUKS
#   - Btfs
#   - Subvolumes:
#     - /root, /
#     - /mikel, /home/mikel
#     - /nix, /nix
#     - /log, /var/log
#     - /tmp, /tmp
#     - /swap, swapfile, 64 GB

{
  device ? throw "No disk device.",
  passwd ? throw "No LUKS password file.",
  ...
}:

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
              ESP = {
                start = "1M";
                size = "1G";

                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };

              crypt = {
                size = "100%";
                label = "crypt";

                content = {
                  type = "luks";
                  name = "root";

                  extraOpenArgs = [
                    "--allow-discards"
                    "--perf-no_read_workqueue"
                    "--perf-no_write_workqueue"
                  ];

                  settings = {
                    crypttabExtraOpts = [
                      "fido2-device=auto"
                      "token-timeout=10"
                    ];
                    allowDiscards = true;
                    keyFile = builtins.toPath passwd;
                  };

                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "-L"
                      "nixos"
                      "-f"
                    ];

                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = [
                          "subvol=root"
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/mikel" = {
                        mountpoint = "/home/mikel";
                        mountOptions = [
                          "subvol=mikel"
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "subvol=nix"
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/log" = {
                        mountpoint = "/var/log";
                        mountOptions = [
                          "subvol=log"
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/tmp" = {
                        mountpoint = "/tmp";
                        mountOptions = [
                          "subvol=tmp"
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/swap" = {
                        mountpoint = "/swap";
                        swap = {
                          swapfile = {
                            size = "64G";
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
