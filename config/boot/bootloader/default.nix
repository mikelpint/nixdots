{
  imports = [ ./grub ./systemd-boot ];

  boot = {
    loader = { timeout = 0; };

    kernelParams = [ "splash" ];
  };
}
