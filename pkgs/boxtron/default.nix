{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,

  dosbox,
  inotify-tools,
  timidity,
  soundfont-fluid,
  fluidsynth,
  # shellcheck,
  # pylint,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "boxtron";
  version = "git";
  commit = "b3eb8c18ec11562ec69675736b4df3fcb04a28a6";

  src = fetchFromGitHub {
    owner = "dreamer";
    repo = "boxtron";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "jxYLKKxlPWS2ZFsxDN8qgcgrzXOIbPeU0U2fNIsZbz4=";
  };

  buildInputs = [
    dosbox
    inotify-tools
    timidity
    soundfont-fluid
    fluidsynth
    # shellcheck
    # pylint
  ];

  buildPhase = ''
    make boxtron.vdf
    make preconfig.tar
  '';

  installPhase = ''
    mkdir -p $out/share/steam/compatibilitytools.d
    mv boxtron.vdf $out/share/steam/compatibilitytools.d
    chmod 644 $out/share/steam/compatibilitytools.d/boxtron.vdf

    mkdir -p $out/bin
    mv install-gog-game $out/bin
    chmod 755 $out/bin/install-gog-game

    mkdir -p $out/share/boxtron
    mv run-dosbox $out/share/boxtron
    mv *.py $out/share/boxtron
    chmod 644 $out/share/boxtron/*.py
    mv preconfig.tar $out/share/boxtron
    chmod 644 $out/share/boxtron/preconfig.tar
    mv toolmanifest.vdf $out/share/boxtron
    chmod 644 $out/share/boxtron/toolmanifest.vdf

    mkdir -p $out/share/doc/boxtron
    mv README.md $out/share/doc/boxtron
    chmod 644 $out/share/doc/boxtron/README.md

    mkdir -p $out/share/licenses/boxtron
    mv LICENSE $out/share/licenses/boxtron
    chmod 644 $out/share/licenses/boxtron/LICENSE
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "$out/share/boxtron/run-boxtron --version 2>&1; return 0";
      };
    };
  };

  meta = with lib; {
    homepage = "https://luxtorpeda.gitlab.io";
    description = "Steam Play compatibility tool to run DOS games using native Linux DOSBox.";
    longDescription = ''
      Steam Play compatibility tool to run DOS games using native Linux DOSBox

      This is a sister project of [Luxtorpeda](https://github.com/dreamer/luxtorpeda), [Roberta](https://github.com/dreamer/roberta), and [DOSBox Staging](https://dosbox-staging.github.io/).
    '';
    maintainers = [ ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
})
