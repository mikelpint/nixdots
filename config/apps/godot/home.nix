{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
let
  has-godot =
    let
      find =
        let
          godot = lib.getName godot;
        in
        x: (if lib.attrsets.isDerivation x then lib.getName x else null) == godot;
    in
    builtins.any find config.home.packages || builtins.any find osConfig.environment.systemPackages;
in
{
  # imports = lib.optional has-godot-mono ../../langs/csharp/home.nix;

  home = {
    packages =
      with pkgs;
      with godotPackages;
      [
        godot
        export-template

        # godot-mono
        # export-template-mono
      ];
  };

  xdg = lib.mkIf false {
    dataFile =
      (
        let
          source =
            let
              find =
                let
                  export-template = lib.getName pkgs.godotPackages.export-template;
                in
                x: (lib.getName x) == export-template;
            in
            lib.lists.findFirst find (lib.lists.findFirst find null
              osConfig.environment.systemPackages
            ) config.home.packages;
        in
        lib.mkIf (source != null) {
          "godot/export_templates/${builtins.replaceStrings [ "-" ] [ "." ] (lib.getVersion source)}" = {
            inherit source;
          };
        }
      )
      // (
        let
          source =
            let
              find =
                let
                  export-template-mono = lib.getName pkgs.godotPackages.export-template-mono;
                in
                x: (if lib.attrsets.isDerivation x then lib.getName x else null) == export-template-mono;
            in
            lib.lists.findFirst find (lib.lists.findFirst find null
              osConfig.environment.systemPackages
            ) config.home.packages;
        in
        lib.mkIf (source != null) {
          "godot/export_templates/${builtins.replaceStrings [ "-" ] [ "." ] (lib.getVersion source)}" = {
            inherit source;
          };
        }
      );
  };

  programs = {
    zed-editor = lib.mkIf false {
      extensions = lib.optional has-godot "gdscript";
    };
  };
}
