{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ pavucontrol ];
  };

  programs = {
    mangohud = {
      settingsPerApplication = {
        pavucontrol = {
          no_display = true;
        };
      };
    };
  };
}
