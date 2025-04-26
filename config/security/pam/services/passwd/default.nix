{
  security = {
    pam = {
      services = {
        passwd = {
          rules = {
            password = {
              "unix" = {
                settings = {
                  rounds = 65536;
                };
              };
            };
          };
        };
      };
    };
  };
}
