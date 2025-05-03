{ lib, ... }:
{
  imports = [
    ./binfmt
    ./fs
    ./lsm
    ./proc
  ];

  boot = {
    kernelParams = [
      "kernel.modules_disabled=0"
      "module.sig_enforce=1"
    ];
    kernel = {
      sysctl = {
        "kernel.unprivileged_userns_clone" = "0";
        "kernel.sysrq" = "0";
        "kernel.io_uring_disabled" = "2";
        "kernel.dmesg_restrict" = "1";
        "kernel.kexec_load_disabled" = lib.mkOverride 900 "1";
        "kernel.kptr_restrict" = lib.mkOverride 900 "2";
        "kernel.printk" = lib.mkOverride 900 "3 3 3 3";
        "kernel.core_pattern" = "|/bin/false";
        "kernel.perf_event_paranoid" = "3";
        "kernel.perf_cpu_time_max_percent" = "1";
        "kernel.perf_event_max_sample_rate" = "1";
      };
    };
  };

  security = {
    forcePageTableIsolation = true;
  };

  environment = {
    etc = {
      "modprobe.d/nm-module-blacklist.conf" = {
        # https://github.com/Kicksecure/security-misc/blob/e154d0af6dd41e392122fbe3d09219734c5ad588/etc/modprobe.d/30_security-misc_blacklist.conf
        # https://github.com/GrapheneOS/infrastructure/blob/b20cf862a315b4f55a7796351130f615453fe88b/etc/modprobe.d/local.conf
        text = ''
          blacklist amd76x_edac
          blacklist ath_pci
          blacklist cdrom
          blacklist cfg80211
          blacklist evbug
          blacklist floppy
          blacklist intel_agp
          blacklist joydev
          blacklist mousedev
          blacklist pcspkr
          blacklist pcspkr
          blacklist psmouse
          blacklist snd_aw2
          blacklist snd_intel8x0
          blacklist snd_intel8x0m
          blacklist snd_pcsp
          blacklist sr_mod
          blacklist tls
          blacklist usbkbd
          blacklist usbmouse
          blacklist virtio_balloon
          blacklist virtio_console
        '';
      };
    };
  };
}
