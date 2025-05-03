_: {
  imports = [ ./services ];

  security = {
    pam = {
      loginLimits = [
        {
          domain = "*";
          item = "core";
          type = "hard";
          value = "0";
        }
      ];
    };
  };
}
