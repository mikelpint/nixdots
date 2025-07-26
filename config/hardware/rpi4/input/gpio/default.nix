_: {
  imports = [
    ../../../common/input/gpio
  ];

  services = {
    udev = {
      extraRules = ''
        SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
      '';
    };
  };
}
