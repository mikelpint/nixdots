{ ... }:

{
  imports = [
    ./amd
    ./nvidia
    # ./vfio
  ];

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
