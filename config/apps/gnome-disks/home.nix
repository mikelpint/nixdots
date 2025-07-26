{ pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        gnome-disk-utility = super.gnome-disk-utility.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/gnome-disks \
              --run '${pkgs.xorg.xhost}/bin/xhost +SI:localuser:root; '
          '';
        });
      })
    ];
  };

  home = {
    packages = with pkgs; [
      gnome-disk-utility
    ];
  };
}
