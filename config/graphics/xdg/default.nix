{ inputs, pkgs, ... }: {
  xdg = {
    portal = {
      config = { common = { default = "*"; }; };
      extraPortals = [ # inputs.xdg-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
