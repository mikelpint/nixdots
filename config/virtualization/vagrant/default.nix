{
  imports = [ ../../boot/fs/nfs ];

  services = {
    nfs = {
      server = {
        enable = true;
      };
    };
  };
}
