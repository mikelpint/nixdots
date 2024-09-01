{ pkgs, ... }:
{
  # imports = [ ./protonvpn ];
  environment = {
    systemPackages = with pkgs; [ wireguard-tools ];
  };
}
