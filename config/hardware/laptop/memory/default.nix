_: {
  imports = [ ../../common/memory/zswap ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024;
    }
  ];
}
