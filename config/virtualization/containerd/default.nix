{
  virtualisation = {
    containerd = {
      enable = lib.mkDefault true;

      settings = {
        grpc = {
          address = "/run/containerd/containerd.sock";
        };
      };
    };
  };
}
