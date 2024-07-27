{ pkgs, ... }:

{
  hardware = {
    amdgpu = {
      initrd = { enable = true; };
      amdvlk = { enable = true; };
      opencl = { enable = true; };
    };

    graphics = {
      extraPackages = (with pkgs; [ amdvlk ])
        ++ (if pkgs ? rocmPackages.clr then
          with pkgs.rocmPackages; [ clr clr.icd ]
        else
          with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ]);

      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };

  services = { xserver = { videoDrivers = [ "amdgpu" ]; }; };

  systemd = {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };

    services = {
      lactd = {
        description = "AMDGPU Control Daemon";
        enable = true;
        serviceConfig = { ExecStart = "${pkgs.lact}/bin/lact daemon"; };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  environment = { systemPackages = with pkgs; [ lact ]; };
}
