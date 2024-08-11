{ pkgs, ... }:
{
  hardware = {
    keyboard = {
      qmk = {
        enable = true;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      qmk
      via
    ];
  };

  services = {
    udev = {
      packages = [ pkgs.via ];
    };
  };
}
