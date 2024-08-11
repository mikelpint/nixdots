{ pkgs, ... }:
{
  systemd = {
    package = pkgs.systemd.override { withSelinux = true; };
  };

  environment = {
    systemPackages = with pkgs; [ policycoreutils ];
  };
}
