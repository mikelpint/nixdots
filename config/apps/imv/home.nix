{ pkgs, ... }: {
  home = { packages = with pkgs; [ imv ]; };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = builtins.zipAttrsWith (_: values: values) (let
        subtypes = type: program: subt:
          builtins.listToAttrs (builtins.map (x: {
            name = type + "/" + x;
            value = program;
          }) subt);
      in [
        (subtypes "image" "imv-folder.desktop" [
          "png"
          "jpeg"
          "gif"
          "svg"
          "svg+xml"
          "tiff"
          "x-tiff"
          "x-dcraw"
        ])
      ]);
    };
  };

  catppuccin = {
    imv = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
