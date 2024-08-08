{ pkgs, inputs, ... }:

let
  proton-ge = (import inputs.nur {
    inherit pkgs;
    nurpkgs = pkgs;
  }).repos.ataraxiasjel.proton-ge;
in {
  home = {
    packages = with pkgs; [ steam proton-ge ];

    sessionVariables = { STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${proton-ge}"; };
  };
}
