{ lib, ... }: {
  #age = {
  #  secrets = {
  #    luks-passwd = {
  #      rekeyFile = "${self}/secrets/luks-passwd.age";
  #    };
  #  };
  #};

  boot = {
    initrd = {
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

      systemd = { enable = lib.mkForce true; };

      luks = {
        cryptoModules = [
          "aes"
          "aes_generic"
          "blowfish"
          "twofish"
          "serpent"
          "cbc"
          "xts"
          "lrw"
          "sha1"
          "sha256"
          "sha512"
          "af_alg"
          "algif_skcipher"
        ];

        #yubikeySupport = true;

        devices = {
          crypt = {
            allowDiscards = true;
            #keyFile = config.age.secrets.luks-passwd.path;

            #yubikey = {
            #  slot = 2;
            #  twoFactor = false;
            #  gracePeriod = 500;
            #};
          };
        };
      };
    };
  };
}
