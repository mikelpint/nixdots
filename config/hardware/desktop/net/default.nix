{
  imports = [
    ./dhcp
    ./dns
    ./if
    ./kernel
  ];

  networking = {
    hostId = "deadbeef";
    hostName = "desktopmikel";
    domain = "mikelpint.com";

    defaultGateway = "192.168.1.1";
  };
}
