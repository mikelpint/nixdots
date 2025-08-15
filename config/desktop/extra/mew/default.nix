{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs = lib.mkIf (config.catppuccin.enable or false) {
    overlays = [
      (_self: super: {
        mew = super.mew.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          patchPhase = ''

          '';
        });
      })
    ];
  };
}
