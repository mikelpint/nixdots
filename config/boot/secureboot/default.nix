{
  lib,
  pkgs,
  config,
  ...
}:
{
  environment = lib.mkIf (config.boot.lanzaboote.enable or false) {
    systemPackages = with pkgs; [ sbctl ];
  };

  boot = {
    lanzaboote = {
      enable = lib.mkDefault (
        let
          hostPlatform = pkgs.system or config.nixpkgs.hostPlatform or "";
        in
        (if builtins.isAttrs hostPlatform then hostPlatform.system or "" else hostPlatform)
        == "x86_64-linux"
      );
      pkiBundle = "/var/lib/sbctl";
    };

    loader = lib.mkIf (config.boot.lanzaboote.enable or false) {
      grub = {
        enable = lib.mkForce false;
      };

      systemd-boot = {
        enable = lib.mkForce false;
      };
    };
  };
}
