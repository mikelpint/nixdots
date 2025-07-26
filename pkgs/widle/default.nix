{
  lib,
  stdenv,
  fetchFromGitea,
  testers,

  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "widle";
  version = "git";
  commit = "63a040494ec022612d32ee1f958753657dd363f2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "widle";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "DrAZL7LTWKjiCOJi4VOqT/ZmU9uUsSs1ZTo8qtui1mg=";
  };

  buildInputs = [
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

  installPhase = ''
    mkdir -p $out/bin
    mv widle $out/bin
    chmod 755 $out/bin/widle

    mkdir -p $out/share/man/man1
    mv widle.1 $out/share/man/man1
    chmod 644 $out/share/man/man1/widle.1
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "widle -v 2>&1; return 0";
      };
    };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/sewn/widle";
    description = "Run a command upon becoming idle.";
    longDescription = ''
      widle is a tiny application that runs a command upon becoming idle utilizing the `ext-idle-notify-v1` protocol.
    '';
    license = licenses.mit;
    inherit (wayland.meta) platforms;
    mainProgram = "widle";
  };
})
