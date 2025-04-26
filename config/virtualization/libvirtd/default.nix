# https://github.com/bryansteiner/gpu-passthrough-tutorial

{ pkgs, ... }:
let
  kvmConf = "/var/lib/libvirt/hooks/kvm.conf";

  alloc_hugepages = pkgs.writeShellScript "alloc_hugepages.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    ## Calculate number of hugepages to allocate from memory (in MB)
    HUGEPAGES="$(( $MEMORY / $(($(grep Hugepagesize /proc/meminfo | awk '{print $2}') / 1024))))"

    echo "Allocating hugepages..."
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo "Succesfully allocated $ALLOC_PAGES / $HUGEPAGES"
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo "Not able to allocate all hugepages. Reverting..."
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi
  '';

  dealloc_hugepages = pkgs.writeShellScript "alloc_hugepages.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    echo 0 > /proc/sys/vm/nr_hugepages
  '';

  bind_vfio = pkgs.writeShellScript "bind_vfio.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    ## Load vfio
    modprobe vfio
    modprobe vfio_iommu_type1
    modprobe vfio_pci

    ## Unbind gpu from nvidia and bind to vfio
    virsh nodedev-detach $VIRSH_GPU_VIDEO
    virsh nodedev-detach $VIRSH_GPU_AUDIO
    virsh nodedev-detach $VIRSH_GPU_USB
    virsh nodedev-detach $VIRSH_GPU_SERIAL
    ## Unbind ssd from nvme and bind to vfio
    # virsh nodedev-detach $VIRSH_NVME_SSD
  '';

  unbind_vfio = pkgs.writeShellScript "unbind_vfio.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    ## Unbind gpu from vfio and bind to nvidia
    virsh nodedev-reattach $VIRSH_GPU_VIDEO
    virsh nodedev-reattach $VIRSH_GPU_AUDIO
    virsh nodedev-reattach $VIRSH_GPU_USB
    virsh nodedev-reattach $VIRSH_GPU_SERIAL
    ## Unbind ssd from vfio and bind to nvme
    # virsh nodedev-reattach $VIRSH_NVME_SSD

    ## Unload vfio
    modprobe -r vfio_pci
    modprobe -r vfio_iommu_type1
    modprobe -r vfio
  '';

  cpu_mode_performance = pkgs.writeShellScript "cpu_mode_performance.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    ## Enable CPU governor performance mode
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo "performance" > $file; done
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  '';

  cpu_mode_ondemand = pkgs.writeShellScript "cpu_mode_ondemand.sh" ''
    #!/usr/bin/env bash

    ## Load the config file
    source "${kvmConf}"

    ## Enable CPU governor on-demand mode
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo "ondemand" > $file; done
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  '';
in
{
  imports = [ ./vm ];

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

      hooks = {
        qemu = {
          inherit alloc_hugepages;
          inherit dealloc_hugepages;

          inherit bind_vfio;
          inherit unbind_vfio;

          inherit cpu_mode_performance;
          inherit cpu_mode_ondemand;
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

      (writeTextFile {
        name = "kvmConf";
        destination = kvmConf;
        text = ''
          MEMORY=32768

          ## Virsh devices
          VIRSH_GPU_VIDEO=pci_0000_07_00_0
          VIRSH_GPU_AUDIO=pci_0000_07_00_1
          VIRSH_GPU_USB=pci_0000_07_00_2
          VIRSH_GPU_SERIAL=pci_0000_07_00_3
          VIRSH_NVME_SSD=pci_0000_01_00_0
        '';
      })

      (writeTextFile {
        name = "libvirtd-qemu-hook-helper-tool";
        destination = "/var/lib/libvirtd/hooks/qemu";
        executable = true;
        text = ''
          #!/usr/bin/env bash
          #
          # Author: SharkWipf
          #
          # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
          # After this file is installed, restart libvirt.
          # From now on, you can easily add per-guest qemu hooks.
          # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
          # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
          #

          GUEST_NAME="$1"
          HOOK_NAME="$2"
          STATE_NAME="$3"
          MISC="$\{@:4}"

          BASEDIR="$(dirname $0)"

          HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

          set -e # If a script exits with an error, we should as well.

          # check if it's a non-empty executable file
          if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH" ] && [ -x "$HOOKPATH" ]; then
              eval \"$HOOKPATH\" "$@"
          elif [ -d "$HOOKPATH" ]; then
              while read file; do
                  # check for null string
                  if [ ! -z "$file" ]; then
                    eval \"$file\" "$@"
                  fi
              done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
          fi
        '';
      })
    ];
  };
}
