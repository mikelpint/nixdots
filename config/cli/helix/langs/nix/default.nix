{ pkgs, ... }: {
  programs = {
    helix = {
      languages = {
        language = [{
          name = "nix";

          auto-format = true;
          formatter = { command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt"; };
        }];
      };
    };
  };
}
