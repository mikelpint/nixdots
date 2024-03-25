{ inputs, pkgs, ... }:

{
  programs = {
    nix-ld = {
      enable = true;
      packages = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };
  };
}
