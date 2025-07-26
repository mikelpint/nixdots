_: {
  virtualisation = {
    containerd = {
      enable = true;

      settings = {
        grpc = {
          address = "/run/containerd/containerd.sock";
        };
      };
    };
  };
}
