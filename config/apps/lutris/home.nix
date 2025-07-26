{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  programs = {
    lutris = {
      enable = true;
      package = pkgs.lutris;

      extraPackages = with pkgs; [
        adwaita-icon-theme
      ];

      steamPackage = osConfig.programs.steam.package or pkgs.steam;
      protonPackages =
        let
          filter = lib.lists.filter (x: lib.attrsets.isDerivation x && builtins.hasAttr "steamcompattool" x);
        in
        filter (osConfig.programs.steam.extraCompatPackages or [ pkgs.proton-proton-ge-bin ]);
      # winePackages =
      #   let
      #     filter = lib.lists.filter (
      #       x: lib.attrsets.isDerivation x && (builtins.match "^wine(-wow)?.*" (if lib.attrsets.isDerivation x then lib.getName x else null)) != null
      #     );
      #   in
      #   (filter osConfig.environment.systemPackages) ++ (filter config.home.packages);

      runners = {
        "86box" = { };
        ags = { };
        atari800 = { };
        basiliskii = { };
        cemu = { };
        citra = { };
        colem = { };
        desmume = { };
        dgen = { };
        dolphin = { };
        dosbox = { };
        duckstation = { };
        easyrpg = { };
        flatpak = { };
        frotz = { };
        fsuae = { };
        hatari = { };
        jzintv = { };
        libretro = { };
        linux = { };
        mame = { };
        mednafen = { };
        melonds = { };
        mgba = { };
        microm8 = { };
        minivmac = { };
        mupen64plus = { };
        o2em = { };
        osmose = { };
        pcem = { };
        pcsx2 = { };
        pico8 = { };
        ppsspp = { };
        redream = { };
        reicast = { };
        rosaliesmupengui = { };
        rpcs3 = { };
        ruffle = { };
        ryujinx = { };
        scummvm = { };
        sheepshaver = { };
        snes9x = { };
        speccy = { };
        steam = { };
        stella = { };
        supermodel = { };
        tic80 = { };
        vice = { };
        virtualjaguar = { };
        vita3k = { };
        web = { };
        wine = { };
        xemu = { };
        yuzu = { };
        zdoom = { };
      };
    };
  };
}
