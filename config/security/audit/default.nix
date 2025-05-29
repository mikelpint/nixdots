{ lib, ... }:
{
  security = {
    audit = {
      enable = true;
      backlogLimit = lib.mkDefault 8192;

      rules = lib.mkDefault [ "-a exit,always -F arch=b64 -S execve" ];
    };

    auditd = {
      enable = true;
    };
  };
}
