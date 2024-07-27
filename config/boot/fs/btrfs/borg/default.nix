{ pkgs, ... }: {
  environment = { systemPackages = with pkgs; [ borgbackup ]; };

  services = { borgbackup = { }; };
}
