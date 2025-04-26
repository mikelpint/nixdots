{
  security = {
    pam = {
      services = {
        system-login = {
          failDelay = {
            delay = "4000000";
          };
        };
      };
    };
  };
}
