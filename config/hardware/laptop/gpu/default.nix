{
  imports = [ ./amd ./nvidia ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  services = { xserver = { enable = true; }; };
}
