_: {
  imports = [ ./flakes ];

  nix = {
    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "nix-command"
      ];
    };
  };
}
