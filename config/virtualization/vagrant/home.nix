{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      [
        (vagrant.override {
          withLibvirt =
            false; # https://github.com/NixOS/nixpkgs/issues/348938#issuecomment-2418403735
        })
      ];
  };
}
