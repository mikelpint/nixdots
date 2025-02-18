{ pkgs, ... }: {
  programs = {
    helix = {
      languages = {
        language = [{
          name = "nix";

          auto-format = true;
          formatter = { command = "${pkgs.treefmt}/bin/treefmt"; };
        }];
      };
    };
  };
}
