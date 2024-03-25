{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      grim
      slurp
      swappy

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')
    ];
  };
}
