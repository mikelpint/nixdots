{lib, osConfig, ...}: {
    services = {
        udiskie = {
            enable = lib.mkDefault osConfig.services.udisks2.enable;
            automount = lib.mkDefault true;
            tray = "auto";
            notify = true;
        };
    };
}
