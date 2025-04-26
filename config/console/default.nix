_: {
  imports = [ ./tty ];

  boot = {
    kernelParams = [
      "boot.shell_on_fail"
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
