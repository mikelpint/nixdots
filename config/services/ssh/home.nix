{
  programs = {
    ssh = {
      enable = true;

      forwardAgent = true;
      hashKnownHosts = true;
    };
  };

  home = {
    sessionVariables = {
      SSH_ASKPASS_REQUIRE = "never";
    };
  };
}
