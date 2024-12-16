{ pkgs, ... }:

let
  extraGroups = [
    "docker"
    "i2c"
    "input"
    "kvm"
    "libvirtd"
    "networkmanager"
    "openrazer"
    "plugdev"
    "sev"
    "storage"
    "vboxsf"
    "vboxusers"
    "video"
    "wheel"
  ];
in
{
  users = {
    users = {
      mikel = {
        uid = 1000;

        description = "Mikel Pintado";
        isNormalUser = true;
        home = "/home/mikel";

        inherit extraGroups;

        hashedPassword = "";

        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };

    groups =
      {
        mikel = {
          gid = 1000;
        };
      }
      // (builtins.listToAttrs (
        builtins.map (name: {
          inherit name;
          value = { };
        }) extraGroups
      ));
  };

  security = {
    doas = {
      extraRules = [ { users = [ "mikel" ]; } ];
    };
  };
}
