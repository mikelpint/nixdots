{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium.override {
        commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];

        enableWideVine = true;
      };

      nativeMessagingHosts = with pkgs; [ web-eid-app ];
    };
  };

  xdg = lib.mkIf (config.programs.chromium.enable or false) {
    configFile =
      let
        web-eid-app = lib.lists.findFirst (
          let
            web-eid-app = lib.getName pkgs.web-eid-app;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == web-eid-app
        ) null (config.programs.chromium.nativeMessagingHosts or [ ]);
      in
      lib.mkIf (web-eid-app != null) {
        "chromium/NativeMessagingHosts/eu.webeid.json" = {
          source = "${web-eid-app}/share/web-eid/eu.webeid.json";
        };

        "google-chrome/NativeMessagingHosts/eu.webeid.json" = {
          source = "${web-eid-app}/share/web-eid/eu.webeid.json";
        };
      };
  };

  nixpkgs = {
    config = builtins.listToAttrs (
      builtins.map
        (name: {
          inherit name;

          value = {
            cupsSupport = true;
            proprietaryCodecs =
              config.nixpkgs.config.allowUnfree or osConfig.nixpkgs.config.allowUnfree or false;
            # pulseSupport = false;
          };
        })
        [
          "chromiumUnwrapped"
          "ungoogled-chromium"
          "chromium"
          "google-chrome"
        ]
    );
  };
}
