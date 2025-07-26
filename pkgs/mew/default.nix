{
  lib,
  stdenv,
  testers,
  fetchFromGitea,

  fcft,
  libxkbcommon,
  pixman,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mew";
  version = "git";
  commit = "af6440da8fe6683cf0b873e0a98c293bf02c3447";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "mew";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "NbpYITHO81fnaDY0dtolaUBdRqQNKwHQz/lBQMOHM5c=";
  };

  buildInputs = [
    fcft
    libxkbcommon
    pixman
    pkg-config
    wayland
    wayland-protocols
    wayland-scanner
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=${lib.getExe wayland-scanner}"
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ];

  buildPhase = ''
    make
  '';

  postPatch = ''
    substituteInPlace mew-run \
        --replace-fail "mew -e \"\$@\"" "$out/bin/mew -e \"\$@\""
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv mew $out/bin
    chmod 755 $out/bin/mew
    mv mew-run $out/bin
    chmod 755 $out/bin/mew-run

    mkdir -p $out/share/man/man1
    sed "s/VERSION/${finalAttrs.version}${
      lib.optionalString (finalAttrs.version == "git") "-${finalAttrs.commit}"
    }/g" < mew.1 > $out/share/man/man1/mew.1
    chmod 644 $out/share/man/man1/mew.1
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "mew -v 2>&1; return 0";
      };
    };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/sewn/mew";
    description = "Dynamic menu for Wayland";
    longDescription = ''
      mew is a efficient dynamic menu for Wayland, an effective port of dmenu to Wayland.
    '';
    license = licenses.mit;
    maintainers = [ ];
    inherit (wayland.meta) platforms;
    mainProgram = "mew";
  };
})
