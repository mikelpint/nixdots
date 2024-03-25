let
  pkgs = import <nixpkgs> {
    config = { };
    overlays = [ ];
  };
in {
  home-manager = {
    users = {
      mikel = { pkgs, ... }: {
        programs = {
          zsh = {
            enable = true;

            plugins = [
              {
                name = "zsh-syntax-highlighting";
                src = pkgs.fetchFromGitHub {
                  owner = "zsh-users";
                  repo = "zsh-syntax-highlighting";
                  rev = "db085e4661f6aafd24e5acb5b2e17e4dd5dddf3e";
                  sha256 = "iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
                };
              }

              {
                name = "zsh-autosuggestions";
                src = pkgs.fetchFromGitHub {
                  owner = "zsh-users";
                  repo = "zsh-autosuggestions";
                  rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
                  sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
                };
              }
            ];

            oh-my-zsh = {
              enable = true;

              plugins = [
                "git"
                "vagrant"
                "wd"
                "safe-paste"
                "sprunge"
                "tmux"
                "sudo"
                "vscode"
                "battery"
                "copypath"
              ];

              theme = "ys";
            };
          };
        };
      };
    };
  };
}
