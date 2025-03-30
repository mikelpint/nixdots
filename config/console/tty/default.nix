{ pkgs, ... }: {
  imports = [
    # ./1.nix
  ];

  services = {
    getty = {
      autologinUser = null;
      loginProgram = "${pkgs.shadow}/bin/login";
    };
  };
}
