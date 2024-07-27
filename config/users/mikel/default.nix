{ pkgs, ... }: {
  users = {
    users = {
      mikel = {
        uid = 1000;

        description = "Mikel Pintado";
        isNormalUser = true;
        home = "/home/mikel";

        extraGroups = [
          "docker"
          "i2c"
          "input"
          "kvm"
          "libvirtd"
          "networkmanager"
          "openrazer"
          "sev"
          "vboxsf"
          "vboxusers"
          "video"
          "wheel"
        ];

        hashedPassword = "";

        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };

    groups = { mikel = { gid = 1000; }; };
  };

  security = { doas = { extraRules = [{ users = [ "mikel" ]; }]; }; };
}
