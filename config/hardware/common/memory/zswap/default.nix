_: {
  imports = [ ../../../../boot/kernel/patches/zstd ];

  boot = {
    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=zstd"
    ];
  };
}
