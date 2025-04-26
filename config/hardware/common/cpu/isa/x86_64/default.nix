{
  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  boot = {
    kernelParams = [ "ia32_emulation=1" ];
  };
}
