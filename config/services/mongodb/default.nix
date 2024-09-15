{
  imports = [ ./dspace ];

  services = {
    mongodb = {
      enable = true;
    };
  };
}
