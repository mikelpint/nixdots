{ pkgs, ... }: {
  /* xdg = {
       configFile = {
         "bat/themes/Catppuccin Macchiato.tmTheme".text = builtins.readFile
           (pkgs.fetchFromGitHub {
             owner = "catppuccin";
             repo = "bat";
             rev = "b8134f01b0ac176f1cf2a7043a5abf5a1a29457b";
             sha256 = "sha256-gzf0/Ltw8mGMsEFBTUuN33MSFtUP4xhdxfoZFntaycQ=";
           } + "/themes/Catppuccin Macchiato.tmTheme");
       };
     };
  */

  programs = {
    bat = {
      enable = true;

      catppuccin = { enable = true; };
      config = { pager = "less -FR"; };
    };
  };
}
