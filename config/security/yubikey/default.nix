{ pkgs, ... }:

{
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = ''$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH:${
        pkgs.lib.makeLibraryPath (
          with pkgs;
          [
            pcscliteWithPolkit
          ]
        )
      }'';
    };

    systemPackages = with pkgs; [
      ccid
      yubikey-personalization
      yubikey-manager
      yubico-piv-tool
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
      packages = with pkgs; [
        yubikey-personalization
      ];
    };

    pcscd = {
      enable = true;
    };
  };
}
