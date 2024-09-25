{
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (self: super: {
        zstd = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_HAVE_KERNEL_ZSTD = yes;
              CONFIG_KERNEL_ZSTD = yes;
              CONFIG_RD_ZSTD = yes;
              CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD = yes;
              CONFIG_ZRAM_DEF_COMP_ZSTD = yes;
              CONFIG_F2FS_FS_ZSTD = yes;
              CONFIG_UBIFS_FS_ZSTD = yes;
              CONFIG_SQUASHFS_ZSTD = yes;
              CONFIG_PSTORE_ZSTD_COMPRESS = yes;
              CONFIG_CRYPTO_ZSTD = yes;
              CONFIG_ZSTD_COMPRESS = yes;
              CONFIG_ZSTD_DECOMPRESS = yes;
              CONFIG_DECOMPRESS_ZSTD = yes;
            };

            ignoreConfigErrors = true;
          }
        );
      })
    ];
  };
}
