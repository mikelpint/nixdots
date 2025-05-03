{
  inputs,
  pkgs,
  config,
  ...
}:

{
  programs = {
    nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;

      libraries = with pkgs; [
        egl-wayland
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };

  services = {
    envfs = {
      inherit (config.programs.nix-ld) enable;
    };
  };
}
