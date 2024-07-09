{ pkgs, ... }: {
  users = {
    users = {
      mikel = {
        isNormalUser = true;
        home = "/home/mikel";
        description = "Mikel Pintado";
        extraGroups = [
          "docker"
          "input"
          "kvm"
          "libvirtd"
          "networkmanager"
          "openrazer"
          "vboxsf"
          "vboxusers"
          "wheel"
        ];
        hashedPassword = "";
        uid = 1000;
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };

    groups = { mikel = { gid = 1000; }; };
  };

  security = { doas = { extraRules = [{ users = [ "mikel" ]; }]; }; };
}
