{ inputs, ... }: {
  home = {
    username = "mikel";
    homeDirectory = "/home/mikel";

    sessionPath = [ "$HOME/.local/bin" ];

    stateVersion = "23.11";
  };

  programs = { home-manager = { enable = true; }; };

  imports = [
    ./apps
    ./audio
    ./boot
    ./cli
    ./desktop
    ./env
    ./fonts
    ./graphics
    ./hardware
    ./input
    ./langs
    ./locale
    ./net
    ./nix
    ./packages
    ./rice
    ./security
    ./services
    ./time
    ./tools
    ./users
    ./virtualization
  ];

  nixpkgs = {
    config = { allowUnfree = true; };

    overlays = with inputs;
      [
        (final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };

          monolisa-script = prev.stdenvNoCC.mkDerivation {
            pname = "monolisa";
            version = "dev";
            src = monolisa-script;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.ttf $out/share/fonts/opentype/
            '';
          };
        })
      ];
  };

  fonts = { fontconfig = { enable = true; }; };
}
