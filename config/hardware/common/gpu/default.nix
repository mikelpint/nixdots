{ pkgs, ... }:
{
  imports = [
    ./amd
    ./nvidia
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

      #setLdLibraryPath = true;
    };
  };
}
