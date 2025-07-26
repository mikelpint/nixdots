{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        obs-studio = super.obs-studio.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/obs --unset LIBVA_DRIVER_NAME --unset LIBVA_DRIVER
          '';
        });
      })
    ];
  };

  programs = {
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio;

      plugins =
        with pkgs.obs-studio-plugins;
        [
          advanced-scene-switcher
          droidcam-obs
          input-overlay
          obs-backgroundremoval
          obs-command-source
          obs-composite-blur
          obs-freeze-filter
          obs-gradient-source
          obs-gstreamer
          obs-move-transition
          obs-mute-filter
          obs-source-clone
          obs-source-switcher
          obs-tuna
          obs-vaapi
          wlrobs
        ]
        ++ (lib.optionals osConfig.services.pipewire.enable [ obs-pipewire-audio-capture ]);
    };
  };
}
