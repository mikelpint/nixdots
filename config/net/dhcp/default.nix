{
  networking = {
    dhcpcd = {
      enable = lib.mkDefault true;

      wait = "background";
      extraConfig = "noarp";
    };
  };
}
