{
  environment = {
    memoryAllocator = {
      provider = "libc";
    };
  };

  boot = {
    kernelParams = [
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "page_alloc.shuffle=1"
      "randomize_kstack_offset=on"
    ];

    kernel = {
      sysctl = {
        "kernel.randomize_va_space" = "2";

        "vm.swappiness" = "1";
        "vm.mmap_min_addr" = "65536";
        "vm.mmap_rnd_bits" = "32";
        "vm.mmap_rnd_compat_bits" = "16";
        "vm.unprivileged_userfaultfd" = "0";
      };
    };
  };
}
