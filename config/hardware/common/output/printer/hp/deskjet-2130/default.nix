{
  hardware = {
    printers = {
      ensurePrinters = [{
        name = "DeskJet_2130";
        location = "Home";
        deviceUri = "hp:/usb/DeskJet_2130_series?serial=CN61F473MR067S";
        model = "drv:///hp/hpcups.drv/hp-deskjet_2130_series.ppd";
      }];

      ensureDefaultPrinter = "DeskJet_2130";
    };
  };
}
