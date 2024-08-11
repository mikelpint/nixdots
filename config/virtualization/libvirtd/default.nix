{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm = {
          enable = true;
        };
        ovmf = {
          enable = true;
          packages = with pkgs; [
            (OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      qemu-utils

      (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')
    ];
  };
}
