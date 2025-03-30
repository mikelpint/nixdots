{ user, ... }: {
  programs = { wireshark = { enable = true; }; };

  users = {
    users = { "${user}" = { extraGroups = [ "wireshark" ]; }; };

    groups = { wireshark = { }; };
  };
}
