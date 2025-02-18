_: {
  programs = {
    bat = {
      enable = true;

      config = { pager = "less -FR"; };
    };
  };

  home = { shellAliases = { cat = "bat"; }; };

  catppuccin = { bat = { enable = true; }; };
}
