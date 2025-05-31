_: {
  imports = [
    ./extra
    ./hyprland
  ];

  environment = {
    memoryAllocator = {
      provider = "libc";
    };
  };
}
