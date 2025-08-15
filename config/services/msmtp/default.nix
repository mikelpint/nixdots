{
  lib,
  config,
  user,
  self,
  ...
}:
{
  age = {
    secrets = {
      proton-smtp-token = {
        owner = user;
        rekeyFile = "${self}/secrets/proton-smtp-token.age";
      };
    };
  };

  programs = {
    msmtp = {
      enable = lib.mkDefault false;
      setSendmail = true;

      defaults = lib.mkDefault {
        port = 587;

        tls = true;
        tls_starttls = true;

        aliases = "/etc/aliases";
      };

      accounts = {
        default = lib.mkDefault (
          {
            host = "smtp.protonmail.ch";
            port = 587;

            from = lib.mkDefault (
              if ((builtins.hasAttr "domain" (config.networking or { })) && config.networking.domain != null) then
                "${lib.strings.removeSuffix user (config.networking.hostName or "")}@${config.networkin.domain}"
              else
                "mikelpint@protonmail.com"
            );
            set_from_header = true;

            auth = true;
            user = "mikelpint@protonmail.com";
          }
          // (lib.optionalAttrs (builtins.hasAttr "proton-smtp-token" config.age.secrets) {
            passwordeval = "$(< ${config.age.secrets.proton-smtp-token.path})";
          })
        );
      };
    };
  };

  environment = {
    etc = {
      aliases = {
        mode = "0644";

        text = '''';
        # text = lib.mkDefault ''
        # root: ${config.programs.msmtp.accounts.default.from}
        # '';
      };
    };
  };
}
