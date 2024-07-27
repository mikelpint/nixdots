{ inputs, pkgs, ... }: {
  environment.systemPackages = [ pkgs.xdg-desktop-portal-hyprland ];

  xdg = {
    portal = {
      config = { common = { default = "*"; }; };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
