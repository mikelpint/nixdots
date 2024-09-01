{ inputs, pkgs, ... }:

{
  imports = [
    ./amd
    ./nvidia
    ./vfio
  ];

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
