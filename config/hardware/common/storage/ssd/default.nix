{
  services = {
    fstrim = {
      enable = true;
    };
  };

  services = {
    zfs = {
        trim = {
            enable = true;
        };
    };
  };
}
