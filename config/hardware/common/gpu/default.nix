{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./amd
    ./nvidia
  ];

  hardware = {
    graphics = {
      package = lib.mkDefault pkgs.mesa;
      package32 = lib.mkDefault pkgs.pkgsi686Linux.mesa;

      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa

        vaapiVdpau
        libva
        libvdpau
        libvdpau-va-gl
        libva-vdpau-driver

        egl-wayland

        libGL
        libGLU

        vulkan-loader
        #vulkan-validation-layers
        vulkan-extension-layer
      ];

      extraPackages32 =
        with pkgs.pkgsi686Linux;
        with driversi686Linux;
        [
          libva
          libvdpau
          libva-vdpau-driver
        ];
    };
  };

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = lib.mkForce "$LD_LIBRARY_PATH:${
        pkgs.lib.makeLibraryPath (
          with pkgs;
          with xorg;
          [
            icu.dev
            libdecor
            glfw

            libGL
            libGLU

            wayland
            egl-wayland

            pipewire

            vulkan-loader
            #vulkan-validation-layers
            vulkan-extension-layer

            libX11
            libXcursor
            libXi
            libXrandr

            pcscliteWithPolkit
            #stdenv.cc.cc.lib
          ]
        )
      }:/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    };
  };
}
