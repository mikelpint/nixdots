{
  boot = {
    kernel = {
      sysctl = {
        "fs.binfmt_misc.status" = "1";
      };
    };
  };
}
