{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      polkit_gnome

      (writeShellScriptBin "hyprsetup_polkit" ''
        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = { settings = { exec-once = [ "hyprsetup_polkit" ]; }; };
    };
  };
}
