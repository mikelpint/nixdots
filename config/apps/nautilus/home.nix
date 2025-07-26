{ pkgs, lib, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        nautilus = super.nautilus.overrideAttrs (nsuper: {
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
      })
    ];
  };

  services = {
    udiskie = {
      settings = {
        program_options = {
          file_manager = "${lib.getBin pkgs.nautilus}/bin/nautilus";
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      file-roller
      nautilus
      sushi
    ];

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
}
