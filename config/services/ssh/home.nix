{
  programs = {
    ssh = {
      enable = true;

      forwardAgent = true;
      hashKnownHosts = true;

      extraConfig = ''
        Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
        AddKeysToAgent yes
      '';
    };
  };

  home = {
    sessionVariables = {
      SSH_ASKPASS_REQUIRE = "never";
    };
  };
}
