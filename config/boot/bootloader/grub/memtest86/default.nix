{
  boot = {
    loader = {
      grub = {
        memtest86 = {
          enable = true;

          params = [
            "btrace"
            "tslist=0,1,2,3,5,7,9,10,13,14"
          ];
        };
      };
    };
  };
}
