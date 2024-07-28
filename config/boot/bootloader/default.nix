{
  imports = [ ./grub ./systemd-boot ];

  boot = {
    loader = { timeout = 3; };

    kernelParams = [ "splash" ];
  };
}
