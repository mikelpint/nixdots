{
  security = {
    pam = {
      services = {
        hyprlock = { text = "\n            auth include login\n          "; };
      };
    };
  };
}
