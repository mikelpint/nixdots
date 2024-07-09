{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      pubKeyAuthentication = true;
    };
  };
}
