{
  imports = [ ./lsm ];

  boot = {
    kernelParams = [ "kernel.modules_disabled=0" ];
  };
}
