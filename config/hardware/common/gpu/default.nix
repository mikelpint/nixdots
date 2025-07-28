{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  packages =
    if config.programs.hyprland.enable or false then
      inputs.hyprland.inputs.nixpkgs.legacyPackages."${pkgs.system}"
    else
      pkgs;
  inherit (packages) mesa pkgsi686Linux;
in
{
  imports = [
    ./amd
    ./nvidia
  ];

  hardware = {
    graphics = {
      package = lib.mkDefault mesa;
      package32 = lib.mkDefault pkgsi686Linux.mesa;

      enable = true;
      enable32Bit = true;

      extraPackages =
        with pkgs;
        with packages;
        [
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
        with packages;
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
      LD_LIBRARY_PATH = [
        (pkgs.lib.makeLibraryPath (
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
        ))
      ]
      ++ (lib.optionals false [ "/run/opengl-driver/lib:/run/opengl-driver-32/lib" ]);
    };
  };
}
