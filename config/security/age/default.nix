{
  config,
  inputs,
  pkgs,
  lib,
  self,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      inputs.agenix-rekey.packages."${pkgs.system}".default
      age-plugin-yubikey
      age-plugin-fido2-hmac
      age
      rage
    ];
  };

  age = {
    rekey = {
      agePlugins = with pkgs; [
        age-plugin-yubikey
        age-plugin-fido2-hmac
      ];

      masterIdentities = [ ./yubikey.pub ];

      storageMode = "local";
      localStorageDir = "${self}/secrets/rekeyed/${lib.strings.removeSuffix "mikel" config.networking.hostName}";
    };
  };
}
