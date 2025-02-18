{
  services = {
    clamav = {
      daemon = { enable = false; };

      scanner = {
        enable = true;

        interval = "*-*-* 00:00:00";
      };

      updater = {
        enable = true;

        frequency = 2;
      };

      fangfrisch = {
        enable = true;

        interval = "hourly";
      };
    };
  };
}
