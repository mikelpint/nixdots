{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    powerManagement = {
      powertop = {
        enable = lib.mkDefault (
          (
            (config.boot.kernelPackages.kernel.structuredExtraConfig.CONFIG_DEBUG_FS or lib.kernel.yes)
            == lib.kernel.yes
          )
          && (builtins.all (
            p:
            if builtins.isString p then
              let
                matches = builtins.match "^debugfs=(.*)$";
              in
              builtins.isArray matches && builtins.length matches > 0 && (builtins.elemAt matches 0) != "off"
            else
              false
          ) (config.boot.kernelParams or [ ]))
        );
      };
    };

    environment = lib.mkIf (config.powerManagement.powertop.enable or false) {
      systemPackages = with pkgs; [ powertop ];
    };

    boot = {
      kernelModules = lib.optional (config.powerManagement.powertop.enable or false) "cpufreq_stats";
    };
  }
  // (lib.mkIf (config.powerManagement.powertop.enable or false) (
    import ../../../../../config/boot/kernel/patches/cpufreq-stats {
      inherit
        lib
        config
        pkgs
        ;
    }
  ));
}
