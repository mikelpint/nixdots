_: {
  boot = {
    kernelPatches = [
      {
        name = "zstd";
        patch = null;
        extraConfig = ''
          HAVE_KERNEL_ZSTD y
          KERNEL_ZSTD y
          RD_ZSTD y
          ZSWAP_COMPRESSOR_DEFAULT_ZSTD y
          ZRAM_DEF_COMP_ZSTD y
          F2FS_FS_ZSTD y
          UBIFS_FS_ZSTD y
          SQUASHFS_ZSTD y
          #PSTORE_ZSTD_COMPRESS y
          CRYPTO_ZSTD y
          ZSTD_COMPRESS y
          ZSTD_DECOMPRESS y
          DECOMPRESS_ZSTD y
        '';
      }
    ];
  };
}
