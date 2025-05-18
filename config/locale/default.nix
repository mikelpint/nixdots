{ lib, ... }:
{
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";

    extraLocaleSettings = lib.mkDefault {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
    };

    extraLocales = lib.mkDefault [
      "C.UTF-8"
      "en_US.UTF-8"
      "es_ES.UTF-8"
    ];
  };

  console = {
    useXkbConfig = true;
    keyMap = lib.mkDefault "us";
  };

  services = {
    xserver = {
      xkb = lib.mkDefault {
        variant = "";
        layout = "us";
      };
    };
  };
}
