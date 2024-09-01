{ lib, ... }:
{
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];

      startWhenNeeded = lib.mkDefault true;

      settings = {
        LogLevel = "VERBOSE";

        AllowUsers = null;
        PermitRootLogin = "no";

        PasswordAuthentication = false;
        pubKeyAuthentication = true;
        KbdInteractiveAuthentication = false;

        UseDns = true;
        X11Forwarding = false;

        KexAlgorithms = [
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
      };
    };
  };

  users = {
    users = {
      mikel = {
        openssh = {
          authorizedKeys = {
            keys = [
              ''
                sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBEqfqWY0Be6QEQIPyopc3YfjUVxvDTENqgritRMhYqofrsmAVe6lrWpQdS/vrsKeTRuIdijkw8/HeEwDvxmBV+8AAAAEc3NoOg== mikel
              ''

              ''
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoCEm18/I9rzxUGQWqwixc2avNwaIl/jrr8hypEjwu+ZUPtcfcXpnd3GCvL2t9QuIWcD22WoqvXBX8Xb1Imc8upLOx1/ACMN2AX+xVH3q6DkGvctiMZ/87txsgEJYc7f1BSmSWSwY1u5G3PcA/wY3ioVWbYHsARbOGwu0/RKrBMzFC+vxu0rd8NHOHtegYIh629DcjB29ienlbqP6gJVTmXlsCJR2FnjQnTAnXekPx0xRyZHkvfO7EmXEs1o22v083ESn0bnhC0OoMJFgy1TvtVSqXo0iGZnCKC3CnIofdZsUfzAvfJb1XiBcS1IzuNEuSBdycMOQ6Q36qKO2u/NcIZDv/LVfZG5Bqv39YfXaOwibvFhga2ouRhiL+XNPs6213UgPmjo+nbAHMbw/KOypmGDllsxt2KQnEPxnzT4z2ZXybYSXSQnbwUJ1plgHwuL5Neno+8FQIV/iZgYoJtFY28W96/btG85fylff4yxKE/UD9ByHUZCbEENCfPoulotk= mikel
              ''
            ];
          };
        };
      };
    };
  };
}
