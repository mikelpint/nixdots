{
  boot = {
    kernelModules = [ "r8169" ];

    initrd = {
        kernelModules = [ "r8169" ];
    };
  };
}
