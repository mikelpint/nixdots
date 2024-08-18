{
  imports = [ ./firefox ];

  boot = {
    kernel = {
      sysctl = {
        "vm.max_map_count" = 2147483642;

        "vm.dirty_background_bytes" = 4194304;
        "vm.dirty_bytes" = 4194304;

        "vm.vfs_cache_pressure" = 50;
      };
    };
  };
}
