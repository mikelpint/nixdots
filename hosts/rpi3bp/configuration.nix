_: {
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/hardware/rpi3bp
  ];

  age = {
    rekey = {
      hostPubkey = builtins.readFile ./host.pub;
    };
  };
}
