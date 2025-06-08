_: {
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
  };
}
