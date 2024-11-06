{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ cacert ];

    variables = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };
}
