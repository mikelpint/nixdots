{
  programs = {
    ssh = {
      enable = true;

      forwardAgent = true;
      hashKnownHosts = true;

      extraConfig = ''
        Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
      '';
    };
  };

  home = {
    sessionVariables = {
      SSH_ASKPASS_REQUIRE = "never";
    };
  };
}
