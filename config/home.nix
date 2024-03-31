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
    ./cli
    ./desktop
    ./env
    ./fonts
    ./langs
    ./rice
    ./tools
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
        })
      ];
  };

  fonts = { fontconfig = { enable = true; }; };
}
