{
  imports = [ ./btrfs ];

  fileSystems = { "/" = { noCheck = true; }; };
}
