{ lib, ... }:
{
  environment = {
    memoryAllocator = {
      provider = lib.mkDefault "libc";
    };
  };

  boot = {
    kernel = {
      sysctl = {
        "vm.swappiness" = lib.mkDefault 1;
      };
    };
  };
}
