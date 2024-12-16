{ pkgs, lib, ... }:
{
  home = {
    sessionVariables = {
      GST_PLUGIN_SYSTEM_PATH_1_0 =
        "/run/current-system/sw/lib/gstreamer-1.0/:"
        + (lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
          with pkgs.gst_all_1;
          [
            gstreamer
            gstreamer.dev

            gst-plugins-base
            gst-plugins-good
            gst-plugins-bad
            gst-plugins-ugly

            gst-libav
            gst-vaapi
          ]
        ));
    };
  };

  nixpkgs = {
    overlays = [
      (self: super: {
        gnome = super.gnome.overrideScope (
          gself: gsuper: {
            nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
              buildInputs =
                nsuper.buildInputs
                ++ (
                  with pkgs;
                  with gst_all_1;
                  [
                    gstreamer
                    gstreamer.dev

                    gst-plugins-base
                    gst-plugins-good
                    gst-plugins-bad
                    gst-plugins-ugly

                    gst-libav
                    gst-vaapi
                  ]
                );
            });
          }
        );
      })
    ];
  };

  home = {
    packages = with pkgs; [
      nautilus
      sushi
    ];
  };
}
