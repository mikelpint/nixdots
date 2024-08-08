{ inputs, pkgs, ... }: {
  environment = { systemPackages = [ pkgs.xdg-desktop-portal-hyprland ]; };

  xdg = {
    autostart = { enable = true; };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config = { common = { default = "*"; }; };

      extraPortals = with pkgs;
        [
          xdg-desktop-portal-gtk
          #xdg-desktop-portal-hyprland
        ];
    };
  };
}
