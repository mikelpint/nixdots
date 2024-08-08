# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk/desktop.nix --arg device '"/dev/nvme0n1"'

# Installed on a Samsung 990 Pro 2TB NVMe SSD
# NO swap (80 GB RAM is more than enough)
# Unencrypted

{ device ? throw "No disk device." }:

let
    rootFsOptions = {
        atime = "off";
        xattr = "sa";
        ashift = "13";
        compression = "lz4";
        recordsize = "64K";
    };
in {
  disko = {
    devices = {
      disk = {
        "${device}" = {
          main = {
            device = builtins.toPath device;
            type = "disk";

            partitions = {
              ESP = {
                start = "1M";
                size = "1G";

                type = "EF00";
              };

              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };

      zpool = {
        zroot = {
            type = "zpool";
            mode = "mirror";

            rootFsOptions = rootFsOptions // { # https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
                "com.sun:auto-snapshot" = "false";
            };

            mountpoint = "/";

            datasets = {
                reserved = {
                    size = "20%";
                    options = {
                        "com.sun:auto-snapshot" = "false";
                        mountpoint = "none";
                    };
                };

                home = {
                    type = "zfs_fs";
                    mountpoint = "/home";
                    options = {
                        "com.sun:auto-snapshot" = "true";
                    };
                };

                nix = {
                    type = "zfs_fs";
                    mountpoint = "/nix";
                    options = {
                        "com.sun:auto-snapshot" = "false";
                    };
                };

                tmp = {
                    type = "zfs_fs";
                    mountpoint = "/tmp";
                    options = {
                        "com.sun:auto-snapshot" = "false";
                    };
                };

                root = {
                    type = "zfs_fs";
                    mountpoint = "/root";
                    options = {
                        "com.sun:auto-snapshot" = "true";
                    };
                };

                var = {
                    type = "zfs_fs";
                    mountpoint = "/var";
                    options = {
                        acltype="posixacl";
                        "com.sun:auto-snapshot" = "true";
                    };
                };
            };
        };

        libvirt = {
            type = "zpool";
            mode = "mirror";

            size = "50%";

            rootFsOptions = rootFsOptions // {
                "com.sun:auto-snapshot" = "true";
                canmount = "off";
            };

            mountpoint = "/libvirt";

            datasets = {
                windows = {
                    type = "zfs_volume";
                    size = "50%";
                };
            };
        };
      };
    };
  };
}
