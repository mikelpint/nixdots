# https://gist.github.com/akitaonrails/d4d98b03f1126c81a20eb3ea57027ad2
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# https://github.com/ifd3f/infra/blob/main/machines/chungus/win10.xml

{ pkgs, ... }:

let
  name = "Windows_VFIO";
  kib = 33554432;
in
{
  environment = {
    systemPackages = with pkgs; [
      win-virtio

      (writeText name ''
        <domain type="kvm">
            <name>${name}</name>
            <uuid>43f345f5-ce06-4a41-b3ce-6c39d0a73041</uuid>

            <metadata>
                <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
                    <libosinfo:os id="http://microsoft.com/win/10"/>
                </libosinfo:libosinfo>
            </metadata>

            <memory unit="KiB">${kib}</memory>
            <currentMemory unit="KiB">33554432</currentMemory>
            <memoryBacking>
                <source type="memfd"/>
                <access mode="shared"/>
            </memoryBacking>

            <vcpu placement='static'>16</vcpu>
            <iothreads>2</iothreads>
            <cputune>
                <vcpupin vcpu='0' cpuset='4'/>
                <vcpupin vcpu='1' cpuset='16'/>
                <vcpupin vcpu='2' cpuset='5'/>
                <vcpupin vcpu='3' cpuset='17'/>
                <vcpupin vcpu='4' cpuset='6'/>
                <vcpupin vcpu='5' cpuset='18'/>
                <vcpupin vcpu='6' cpuset='7'/>
                <vcpupin vcpu='7' cpuset='19'/>
                <vcpupin vcpu='8' cpuset='8'/>
                <vcpupin vcpu='9' cpuset='20'/>
                <vcpupin vcpu='10' cpuset='9'/>
                <vcpupin vcpu='11' cpuset='21'/>
                <vcpupin vcpu='12' cpuset='10'/>
                <vcpupin vcpu='13' cpuset='22'/>
                <vcpupin vcpu='14' cpuset='11'/>
                <vcpupin vcpu='15' cpuset='23'/>
            
                <emulatorpin cpuset='3,15'/>
            
                <iothreadpin iothread='1' cpuset='3'/>
                <iothreadpin iothread='2' cpuset='15'/>
            </cputune>

            <cpu mode='host-passthrough' check='none' migratable='on'>
                <topology sockets='1' dies='1' cores='8' threads='2'/>
                <cache mode='passthrough'/>
                <feature policy='require' name='topoext'/>
                <feature policy='disable' name='svm'/>
                <feature policy='require' name='apic'/>
                <feature policy='require' name='hypervisor'/>
                <feature policy='require' name='invtsc'/>
            </cpu>

            <os>
                <type arch='x86_64' machine='pc-q35'>hvm</type>
                <loader readonly='yes' type='pflash'>/run/libvirt/nix-ovmf/OVMF_CODE.fd</loader>
                <nvram>/libvirt/qemu/nvram/${name}.fd</nvram>
                <bootmenu enable='no'/>
                <smbios mode="sysinfo"/>
            </os>


            <sysinfo type="smbios">
                <bios>
                    <entry name="vendor">American Megatrends Inc.</entry>
                    <entry name="version">5013</entry>
                    <entry name="date">03/22/2024</entry>
                </bios>
            
                <system>
                    <entry name="manufacturer">ASUSTeK COMPUTER INC.</entry>
                    <entry name="product">TUF GAMING X570-PLUS (WI-FI)</entry>
                    <entry name="version">X.0x</entry>
                    <entry name="serial">190857269600682</entry>
                    <entry name="uuid">1f29a2a6-f074-9273-4731-04d9f5d24fbf</entry>
                </system>
            </sysinfo>

            <features>
                <acpi/>
                <apic/>
                <hyperv mode='passthrough'>
                    <relaxed state='on'/>
                    <vapic state='on'/>
                    <spinlocks state='on' retries='8191'/>
                    <vpindex state='on'/>
                    <synic state='on'/>
                    <stimer state='on'/>
                    <reset state='on'/>
                    <vendor_id state='on' value='0123756792CD'/>
                    <frequencies state='on'/>
                </hyperv>
                <kvm>
                    <hidden state='on'/>
                </kvm>
                <vmport state='off'/>
                <smm state='on'/>
                <ioapic driver='kvm'/>
            </features>

            <clock offset='localtime'>
                <timer name='rtc' tickpolicy='catchup'/>
                <timer name='pit' tickpolicy='delay'/>
                <timer name='hpet' present='no'/>
                <timer name='hypervclock' present='yes'/>
            </clock>

            <on_poweroff>destroy</on_poweroff>
            <on_reboot>restart</on_reboot>
            <on_crash>destroy</on_crash>

            <pm>
                <suspend-to-mem enabled='no'/>
                <suspend-to-disk enabled='no'/>
            </pm>

            <devices>
                <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>

                <disk type='block' device='disk'>
                    <driver name='qemu' type='raw' cache='none' io='native' discard='unmap'/>
                    <source dev='/dev/zvol/zroot/libvirt/windows' index='2'/>
                    <backingStore/>
                    <target dev='sda' bus='sata'/>
                    <boot order='2'/>
                    <alias name='sata0-0-0'/>
                    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
                </disk>

                <disk type='file' device='cdrom'>
                    <driver name='qemu'/>
                    <target dev='sdb' bus='sata'/>
                    <readonly/>
                    <boot order='1'/>
                    <alias name='sata0-0-1'/>
                    <address type='drive' controller='0' bus='0' target='0' unit='1'/>
                </disk>
            </devices>
        </domain>
      '')
    ];
  };
}
