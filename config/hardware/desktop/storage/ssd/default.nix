{
  imports = [
    ../../../common/storage/ssd
    ../../../common/storage/ssd/nvme
  ];

  services = {
    smartd = {
      devices = [
        {
          device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7DNNJ0WC74273K";
        }

        {
          device = "/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G2_SSD_53HA20G8KS52";
        }

        {
          device = "/dev/disk/by-id/ata-CT1000MX500SSD1_2211E61C826F";
        }

        {
          device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3500G_183137803652";
        }
      ];
    };
  };
}
