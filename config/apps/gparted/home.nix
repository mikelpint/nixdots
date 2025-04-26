{ pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        gparted = super.gparted.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall =
            (old.postInstall or "")
            + ''
              wrapProgram $out/bin/gparted --prefix '${pkgs.xorg.xhost}/bin/xhost +SI:localuser:root; ' --suffix '; ${pkgs.xorg.xhost}/bin/xhost -SI:localuser:root'
            '';
        });
      })
    ];
  };

  home = {
    packages = with pkgs; [
      gparted
    ];
  };
}
