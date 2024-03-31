{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      [ (pkgs.callPackage ../../../pkgs/insomnia.nix { src = insomnia; }) ];
  };
}
