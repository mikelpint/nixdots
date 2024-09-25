_: {
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/hardware/laptop

    ../../presets/desktop
    ../../presets/dev
    ../../presets/music
    ../../presets/rice
    ../../presets/social
    ../../presets/video
  ];

  age = {
    identityPaths = [ "/home/mikel/.ssh/id_ed25519_sk" ];

    rekey = {
      hostPubkey = builtins.readFile ./host.pub;
      masterIdentities = [ "/home/mikel/.ssh/id_ed25519_sk" ];
    };
  };
}
