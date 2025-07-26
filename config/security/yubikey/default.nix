{
  config,
  inputs,
  pkgs,
  lib,
  self,
  user,
  ...
}:
let
  vendor = "Yubico";
  idVendor = "1050";
  idProduct = "0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410";

  tmpfile = "/tmp/yubikey.serial";

  yubikey-notification-add = pkgs.writeShellScriptBin "yubikey-notification-add" ''
    DISPLAY=:0.0
    $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -session)/environ)

    echo $(ykman list -s) | head -1 > "${tmpfile}"
    notify-send "Yubikey plugged in" "$(< ${tmpfile})" -a com.yubico.authenticator.desktop
  '';
  yubikey-notification-remove = pkgs.writeShellScriptBin "yubikey-notification-remove" ''
    DISPLAY=:0.0
    $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -session)/environ)

    notify-send "Yubikey unplugged" "$(< ${tmpfile})" -a com.yubico.authenticator.desktop
    rm "${tmpfile}"
  '';
in
{
  imports = [ ../age ];

  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = [
        "$LD_LIBRARY_PATH"
        "$NIX_LD_LIBRARY_PATH"
        (pkgs.lib.makeLibraryPath (with pkgs; [ pcscliteWithPolkit ]))
      ];
    };

    systemPackages = with pkgs; [
      ccid
      yubikey-personalization
      yubikey-manager
      yubico-piv-tool

      libnotify
      yubikey-notification-add
      yubikey-notification-remove

      age-plugin-yubikey
      age-plugin-fido2-hmac
    ];
  };

  hardware = {
    gpgSmartcards = {
      enable = true;
    };

    ledger = {
      enable = true;
    };
  };

  services = {
    udev = {
      packages = with pkgs; [ yubikey-personalization ];

      extraRules = ''
        SUBSYSTEM=="usb", ENV{ID_VENDOR}="${vendor}" ENV{ID_VENDOR_ID}=="${idVendor}", ENV{ID_MODEL_ID}=="${idProduct}", ENV{ID_SMARTCARD_READER}="1", ENV{ID_SMARTCARD_READER_DRIVER}="gnupg"

        ACTION=="add", ENV{ID_VENDOR}="${vendor}", ENV{ID_VENDOR_ID}=="${idVendor}", ENV{ID_MODEL_ID}=="${idProduct}", RUN+="${yubikey-notification-add}/bin/yubikey-notification-add"
        ACTION=="remove", ENV{ID_VENDOR}="${vendor}", ENV{ID_VENDOR_ID}=="${idVendor}", ENV{ID_MODEL_ID}=="${idProduct}", RUN+="${yubikey-notification-remove}/bin/yubikey-notification-remove"

        ENV{ID_VENDOR}=="${vendor}", ENV{ID_VENDOR_ID}=="${idVendor}", ENV{ID_MODEL_ID}=="${idProduct}", SYMLINK+="yubikey", TAG+="systemd"
      '';
    };

    pcscd = {
      enable = true;
    };
  };

  age = {
    rekey = {
      agePlugins = with pkgs; [
        age-plugin-yubikey
        age-plugin-fido2-hmac
      ];

      masterIdentities =
        let
          inherit
            ((import ../age {
              inherit
                config
                inputs
                pkgs
                lib
                self
                user
                ;
            }).age.rekey
            )
            masterIdentities
            ;
        in
        lib.mkDefault (
          ((if builtins.isAttrs masterIdentities then masterIdentities else { }).content or masterIdentities)
          ++ [ ./yubikey.pub ]
        );
    };
  };

  fileSystems = {
    "/tmp" = {
      neededForBoot = true;
    };

    "/nix" = {
      depends = [ "/tmp" ];
    };
  };
}
