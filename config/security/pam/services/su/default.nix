{
  security = {
    pam = {
      services = {
        su = {
          requireWheel = true;
        };

        su-l = {
          requireWheel = true;
        };
      };
    };
  };
}
