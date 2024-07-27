{
  imports = [ ./dconf ./git ./gnupg ./http ./hwutils ./nix-ld ];

  fileSystems = { "/var/log" = { neededForBoot = true; }; };

  system = { stateVersion = "24.05"; };
}
