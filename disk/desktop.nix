# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk/desktop.nix --arg device /dev/nvme0n1

# Installed on a Samsung 990 Pro 2TB NVMe SSD
# NO swap (80 GB RAM is more than enough)
# Unencrypted
# Layout:
#  - Empty, 1 MB
#  - ESP, 1 GB
#  - ZFS, the rest
#    - Datasets:
#      - reserved, none, 200 GB
#       - user, none
#         - home, /home
#           - mikel, /home/mikel
#           - root, /home/root
#       - system, none
#         - root, /
#         - nix, /nix
#         - var, /var
#      - tmp, /tmp
#      - libvirt, /libvirt
#    - Volumes:
#      - libvirt/windows, 500 GB

{
  device ? throw "No disk device.",
  ...
}:

let
  rootFsOptions = {
    acltype = "posixacl";
    atime = "off";
    xattr = "sa";
    compression = "lz4";
    recordsize = "64K";
  };

  options = {
    ashift = "13";
    autotrim = "on";
  };
in
{
  disko = {
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
          mode = "";

          rootFsOptions = rootFsOptions // {
            # https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
            "com.sun:auto-snapshot" = "false";
          };

          inherit options;

          datasets = {
            reserved = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
                reservation = "200G";
              };
            };

            "user" = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
              };
            };

            "user/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
              options = {
                "com.sun:auto-snapshot" = "false";
              };
            };

            "user/home/mikel" = {
              type = "zfs_fs";
              mountpoint = "/home/mikel";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            "user/home/root" = {
              type = "zfs_fs";
              mountpoint = "/root";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            system = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
              };
            };

            "system/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            "system/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            "system/var" = {
              type = "zfs_fs";
              mountpoint = "/var";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            tmp = {
              type = "zfs_fs";
              mountpoint = "/tmp";
              options = {
                "com.sun:auto-snapshot" = "false";
              };
            };

            "libvirt" = {
              type = "zfs_fs";
              mountpoint = "/libvirt";
              options = {
                "com.sun:auto-snapshot" = "true";
              };
            };

            "libvirt/windows" = {
              type = "zfs_volume";
              size = "500G";
            };
          };
        };
      };
    };
  };
}
