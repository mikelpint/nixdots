{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot = {
    kernelParams = [
      "extra_latent_entropy"
      "random.trust_cpu=on"
      "random.trust_bootloader=on"
    ];

    kernelModules = lib.mkIf config.services.jitterentropy-rngd.enable [ "jitterentropy_rng" ];
  };

  services = {
    jitterentropy-rngd = {
      enable = !config.boot.isContainer;
      package = pkgs.jitterentropy-rngd;
    };
  };
}
