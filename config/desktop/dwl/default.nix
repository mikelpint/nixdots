# https://awesome-yuki.neocities.org/blog/dwl-setup/

{ pkgs, lib, ... }:
{
  nixpkgs = {
    overlays = [
      (_final: prev: {
        dwl = prev.dwl.overrideAttrs {
          enableXWayland = true;

          configH = { };

          patches =
            let
              dwl-patches = pkgs.fetchFromGitea {
                url = "codeberg.org";
                owner = "dwl";
                repo = "dwl-patches";
                rev = "07ad746a6fc90d833497253d891eb0519ad8ed49";
                sha256 = lib.fakeSha256;
              };

              patch = _name: "${dwl-patches}/patches/${patch}.patch";
            in
            builtins.map patch [
              "alwayscenter"
              "bar"
              "cursortheme"
              "gaps"
              "regexrules"
              "regions"
              "swallow"
              "warpcursor"
            ];
        };
      })
    ];
  };
}
