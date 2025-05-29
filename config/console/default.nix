_: {
  imports = [ ./tty ];

  boot = {
    kernelParams = [
      "fbcon=nodefer"
    ];
  };

  catppuccin = {
    tty = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
