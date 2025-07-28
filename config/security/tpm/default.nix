{ config, pkgs, ... }:
{
  security = {
    tpm2 = {
      enable = true;

      applyUdevRules = true;

      tssUser = if config.security.tpm2.abrmd.enable or false then "tss" else "root";
      tssGroup = "tss";

      abrmd = {
        enable = true;
        package = pkgs.tpm2-abrmd;
      };

      pkcs11 = {
        enable = true;
        package = if config.security.tpm2.abrmd.enable then pkgs.tpm2-pkcs11.abrmd else pkgs.tpm2-pkcs11;
      };

      tctiEnvironment = {
        enable = true;
        deviceConf = "/dev/tpmrm0";
        interface = "device";
        tabrmdConf = "bus_name=com.intel.tss2.Tabrmd";
      };
    };
  };

  systemd = {
    tpm2 = {
      enable =
        config.security.tpm2.enable or (config.systemd.package or pkgs.systemd).withTpm2Units or false;
    };
  };
}
