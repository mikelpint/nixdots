_: {
  imports = [ ./fbcat ];

  boot = {
    kernelParams = [
      "fbcon=nodefer"
    ];
  };
}
