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
      "random.trust_cpu=off"
      "random.trust_bootloader=off"
    ];

    kernelModules = lib.mkIf config.services.jitterentropy-rngd.enable [ "jitterentropy_rng" ];
  };

  services = {
    jitterentropy-rngd = {
      enable = !(config.boot.isContainer or false);
      package = pkgs.jitterentropy-rngd;
    };
  };
}
