{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            kb_layout = lib.mkDefault "us, es";
            kb_variant = lib.mkDefault "";
            kb_model = lib.mkDefault "";
            kb_options = lib.mkDefault "grp:win_space_toggle";
            kb_rules = lib.mkDefault "";
          };
        };
      };
    };
  };
}
