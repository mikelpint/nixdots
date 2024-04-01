{
  users = {
    users = {
      mikel = {
        isNormalUser = true;
        home = "/home/mikel";
        description = "Mikel Pintado";
        extraGroups = [ "wheel" ];
        hashedPassword = "";
        uid = 1000;
        useDefaultShell = true;
      };
    };

    groups = { mikel = { gid = 1000; }; };
  };

  security = { doas = { extraRules = [{ users = [ "mikel" ]; }]; }; };
}
