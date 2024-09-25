{ inputs, pkgs, ... }:
{
  environment = {
    systemPackages = [
      inputs.nixpkgs-small.legacyPackages."${pkgs.system}".xdg-desktop-portal-hyprland
    ];
  };

  xdg = {
    autostart = {
      enable = true;
    };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config = {
        common = {
          default = "*";
        };
      };

      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
