{
  imports = [ ./nvidia/home.nix ];

  home = { sessionVariables = { MOZ_DRM_DEVICE = "/dev/dri/card1"; }; };
}
