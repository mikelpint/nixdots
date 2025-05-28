{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [ cacert ];

    variables = {
      SSL_CERT_FILE = lib.mkDefault "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };
}
