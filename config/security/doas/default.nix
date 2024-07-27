{
  security = {
    sudo = { enable = false; };

    doas = {
      enable = true;
      extraRules = [{
        noPass = true;
        keepEnv = true;
      }];
    };
  };

  environment = { shellAliases = { sudo = "doas"; }; };
}
