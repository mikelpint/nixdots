{
  user,
  ...
}:
{
  programs = {
    git = {
      enable = true;
    };
  };

  home-manager = {
    users = {
      root = {
        programs = {
          git = {
            enable = true;
            extraConfig = {
              safe = {
                directory = [ "/etc/nixos" ];
              };
            };
          };
        };
      };

      "${user}" = {
        programs = {
          git = {
            extraConfig = {
              safe = {
                directory = [ "/etc/nixos" ];
              };
            };
          };
        };
      };
    };
  };
}
