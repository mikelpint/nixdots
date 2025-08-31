{
  pkgs,
  lib,
  config,
  osConfig,
  home-manager,
  user,
  ...
}:
{
  home = {
    packages = with pkgs; [
      nasm
      fasm

      ghidra
      ghidra-extensions.findcrypt
      ghidra-extensions.ghidra-delinker-extension
      ghidra-extensions.gnudisassembler
      ghidra-extensions.wasm

      binsider
    ];
  }
  // (
    let
      find =
        x:
        let
          name = if lib.attrsets.isDerivation x then lib.getName x else null;

          ghidra = lib.getName pkgs.ghidra;
          ghidra-bin = lib.getName pkgs.ghidra-bin;
        in
        name == ghidra || name == ghidra-bin;
      ghidra = lib.lists.findFirst find (lib.lists.findFirst find (lib.lists.findFirst find pkgs.ghidra
        osConfig.environment.systemPackages
      ) config.home.packages) [ (osConfig.programs.ghidra.package or { name = ""; }) ];
    in
    lib.mkIf (ghidra != null && (config.catppuccin.enable or false)) {
      activation = {
        "ghidra-theme" =
          home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" (lib.getName ghidra) ]
            ''
              DIR="/home/${user}/.config/ghidra/ghidra_${lib.getVersion ghidra}_NIX"
              mkdir -p "$DIR"

              if [[ ! -f "$DIR/preferences" ]]
              then
                  touch "$DIR/preferences"
              fi

              VALUE=$(echo "$DIR/preferences" | grep "^Theme" | cut -d '=' -f2)
              NEWVAL="File\\:$DIR/themes/Catppucin_${
                (lib.strings.toUpper (lib.strings.substring 0 1 config.catppuccin.flavor))
              }${lib.strings.substring 1 (-1) config.catppuccin.flavor}.theme"

              if [[ -z "$VALUE" ]]
              then
                  run echo "Theme=$NEWVAL" >> "$DIR/preferences"
              else
                  run sed -ri "s/Theme=.*/Theme=\$NEWVAL/g" "$DIR/preferences"
              fi
            '';
      };
    }
  );
}
