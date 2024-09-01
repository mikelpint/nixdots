# https://gist.github.com/akitaonrails/d4d98b03f1126c81a20eb3ea57027ad2
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# https://github.com/ifd3f/infra/blob/main/machines/chungus/win10.xml

{ pkgs, ... }:

let
  name = "win11";
  kib = 33554432;

  xml = pkgs.writeText "vm-${name}" ''
    <domain type="kvm">
        <name>${name}</name>
        <uuid>43f345f5-ce06-4a41-b3ce-6c39d0a73041</uuid>

        <metadata>
            <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
                <libosinfo:os id="http://microsoft.com/win/11"/>
            </libosinfo:libosinfo>
        </metadata>

        <memory unit="KiB">${builtins.toString kib}</memory>
        <currentMemory unit="KiB">${builtins.toString kib}</currentMemory>
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

            <controller type='usb' index='0' model='qemu-xhci' ports='15'>
                <alias name='usb'/>
                <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
            </controller>
                
            <controller type='pci' index='0' model='pcie-root'>
                <alias name='pcie.0'/>
            </controller>
            
            <controller type='pci' index='1' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='1' port='0x10'/>
                <alias name='pci.1'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
            </controller>
            
            <controller type='pci' index='2' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='2' port='0x11'/>
                <alias name='pci.2'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
            </controller>
            
            <controller type='pci' index='3' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='3' port='0x12'/>
                <alias name='pci.3'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
            </controller>
            
            <controller type='pci' index='4' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='4' port='0x13'/>
                <alias name='pci.4'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
            </controller>
            
            <controller type='pci' index='5' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='5' port='0x14'/>
                <alias name='pci.5'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
            </controller>

            <controller type='pci' index='6' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='6' port='0x15'/>
                <alias name='pci.6'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
            </controller>
            
            <controller type='pci' index='7' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='7' port='0x16'/>
                <alias name='pci.7'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
            </controller>
            
                <controller type='pci' index='8' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='8' port='0x17'/>
                <alias name='pci.8'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x7'/>
            </controller>
            
                <controller type='pci' index='9' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='9' port='0x18'/>
                <alias name='pci.9'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0' multifunction='on'/>
            </controller>
            
            <controller type='pci' index='10' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='10' port='0x19'/>
                <alias name='pci.10'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x1'/>
            </controller>
            
            <controller type='pci' index='11' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='11' port='0x1a'/>
                <alias name='pci.11'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x2'/>
            </controller>
            
            <controller type='pci' index='12' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='12' port='0x1b'/>
                <alias name='pci.12'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x3'/>
            </controller>
            
            <controller type='pci' index='13' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='13' port='0x1c'/>
                <alias name='pci.13'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x4'/>
            </controller>
            
            <controller type='pci' index='14' model='pcie-root-port'>
                <model name='pcie-root-port'/>
                <target chassis='14' port='0x1d'/>
                <alias name='pci.14'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
            </controller>
            
            <controller type='sata' index='0'>
                <alias name='ide'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
            </controller>
            
            <controller type='virtio-serial' index='0'>
                <alias name='virtio-serial0'/>
                <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
            </controller>
            
            <interface type='direct'>
                <mac address='52:54:00:7e:41:bc'/>
                <source dev='br0' mode='bridge'/>
                <target dev='macvtap3'/>
                <model type='e1000e'/>
                <alias name='net0'/>
                <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
            </interface>
            
            <serial type='pty'>
                <source path='/dev/pts/3'/>
                <target type='isa-serial' port='0'>
                    <model name='isa-serial'/>
                </target>
                <alias name='serial0'/>
            </serial>
            
            <console type='pty' tty='/dev/pts/3'>
                <source path='/dev/pts/3'/>
                <target type='serial' port='0'/>
                <alias name='serial0'/>
            </console>
            
            <channel type='spicevmc'>
                <target type='virtio' name='com.redhat.spice.0' state='disconnected'/>
                <alias name='channel0'/>
                <address type='virtio-serial' controller='0' bus='0' port='1'/>
            </channel>
            
            <input type='mouse' bus='ps2'>
                <alias name='input0'/>
            </input>
            
            <input type='keyboard' bus='ps2'>
                <alias name='input1'/>
            </input>
            
            <graphics type='spice' port='5900' autoport='yes' listen='127.0.0.1'>
                <listen type='address' address='127.0.0.1'/>
                <image compression='off'/>
            </graphics>
            
            <sound model='ich9'>
                <alias name='sound0'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
            </sound>
            
            <audio id='1' type='spice'/>
            
            <video>
                <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
                <alias name='video0'/>
                <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
            </video>
            
            <hostdev mode='subsystem' type='pci' managed='yes'>
                <driver name='vfio'/>
                <source>
                    <address domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
                </source>
                <alias name='hostdev0'/>
                <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
            </hostdev>
            
            <hostdev mode='subsystem' type='pci' managed='yes'>
                <driver name='vfio'/>
                <source>
                    <address domain='0x0000' bus='0x07' slot='0x00' function='0x1'/>
                </source>
                <alias name='hostdev1'/>
                <address type='pci' domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
            </hostdev>
            
            <hostdev mode='subsystem' type='pci' managed='yes'>
                <driver name='vfio'/>
                <source>
                    <address domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
                </source>
                <alias name='hostdev2'/>
                <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
            </hostdev>
            
            <memballoon model='virtio'>
                <alias name='balloon0'/>
                <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
            </memballoon>
        </devices>

        <seclabel type='dynamic' model='dac' relabel='yes'>
            <label>+0:+0</label>
            <imagelabel>+0:+0</imagelabel>
        </seclabel>
    </domain>
  '';
in
{
  networking = {
    firewall = {
      trustedInterfaces = [
        "virbr0"
        "macvtap1@virbr0"
      ];
    };
  };
}
