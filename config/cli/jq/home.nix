{ osConfig, user, pkgs, ... }: {
  programs = {
    jq = { enable = true; };
    "${if osConfig.users.users.${user}.shell == pkgs.zsh then
      "zsh"
    else
      "bash"}" = {
        initExtra = ''
          jqurl () {
              curl $@ | jq
          }
        '';
      };
  };
}
