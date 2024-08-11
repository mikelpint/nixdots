{
  imports = [ ./tty ];

  boot = {
    kernelParams = [
      "boot.shell_on_fail"
      "fbcon=nodefer"
    ];
  };

  console = {
    catppuccin = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
