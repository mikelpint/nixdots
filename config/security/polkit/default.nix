{
  imports = [ ./rules ];

  security = {
    polkit = {
      enable = true;
    };
  };
}
