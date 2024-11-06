{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [ ];
        extraPkgs = pkgs: [ ];

        # postFixup = ''
        #   $out/bin/lutris --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
        # '';
      })

      adwaita-icon-theme
    ];
  };
}
