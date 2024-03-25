{ pkgs, ... }:

{
  options = {
    hardware = {
      amdgpu = {
        loadInInitrd = true;
        amdvlk = true;
        opencl = true;
      };

      opengl = {
        extraPackages = (with pkgs; [ amdvlk ])
          ++ (if pkgs ? rocmPackages.clr then
            with pkgs.rocmPackages; [ clr clr.icd ]
          else
            with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ]);

        extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
      };
    };
  };

  services = { xserver = { videoDrivers = [ "amdgpu" ]; }; };

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
}
