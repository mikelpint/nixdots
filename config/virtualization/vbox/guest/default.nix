{
  virtualisation = {
    virtualbox = {
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };
  };

  boot = { initrd = { checkJournalingFS = false; }; };

  fileSystems = {
    "/virtualboxshare" = {
      fsType = "vboxsf";
      device = "WD_Black";
      options = [ "rw" "nofail" "uid=1000" "gid=1000" "dmask=007" "fmask=117" ];
    };
  };
}
