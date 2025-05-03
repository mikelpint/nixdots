{ user, ... }:
{
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
    identityPaths = [ "/home/${user}/.ssh/id_rsa" ];

    rekey = {
      hostPubkey = builtins.readFile ./host.pub;
      masterIdentities = [ "/home/${user}/.ssh/id_rsa" ];
    };
  };
}
