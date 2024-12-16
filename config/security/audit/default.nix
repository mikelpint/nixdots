{
  security = {
    audit = {
      enable = true;

      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    auditd = {
      enable = true;
    };
  };
}
