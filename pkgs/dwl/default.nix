# https://github.com/NixOS/nixpkgs/blob/fe51d34885f7b5e3e7b59572796e1bcb427eccb1/pkgs/by-name/dw/dwl/package.nix
# https://codeberg.org/oceanicc/dwl

{
  lib,
  fetchFromGitea,
  writeText,
  installShellFiles,
  stdenv,
  testers,

  bashInteractive,
  fcft,
  libX11,
  libinput,
  libxcb,
  libxkbcommon,
  pixman,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  xcbutilwm,
  xwayland,

  enableXWayland ? true,
  configH ? null,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dwl";
  version = "git";
  commit = "15bfffd87a6f9da0bc551db95c7c2a9a069b3708";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dwl";
    repo = "dwl";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "AvhGE0PGlwtX+wn59kw+9cH3vHa3S+REEOD9IIzHNxU=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    bashInteractive
    fcft
    libinput
    libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots
  ]
  ++ lib.optionals enableXWayland [
    libX11
    xcbutilwm
    xwayland
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=${lib.getExe wayland-scanner}"
    "PREFIX=$(out)"
    "MANDIR=$(man)/share/man"
  ]
  ++ lib.optionals enableXWayland [
    ''''
    ''XWAYLAND="-DXWAYLAND"''
    ''XLIBS="xcb xcb-icccm"''
  ];

  strictDeps = true;

  outputs = [
    "out"
    "man"
  ];

  postPatch = "cp ${
    writeText "config.h" (
      let

        _configH =
          if configH == null then
            builtins.readFile "${finalAttrs.src}/config.def.h"
          else
            (if builtins.isString then configH else builtins.readFile configH);

        conf = _configH;
      in
      conf
    )
  } config.h";

  __structuredAttrs = true;

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "dwl -v 2>&1; return 0";
      };
    };
  };

  meta = {
    homepage = "https://codeberg.org/dwl/dwl";
    changelog = "https://codeberg.org/dwl/dwl/src/${
      if finalAttrs.version == "git" then
        "commit/${
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        }"
      else
        "branch/${finalAttrs.version}"
    }/CHANGELOG.md";
    description = "Dynamic window manager for Wayland";
    longDescription = ''
      dwl is a compact, hackable compositor for Wayland based on wlroots. It is
      intended to fill the same space in the Wayland world that dwm does in X11,
      primarily in terms of philosophy, and secondarily in terms of
      functionality. Like dwm, dwl is:

      - Easy to understand, hack on, and extend with patches
      - One C source file (or a very small number) configurable via config.h
      - Tied to as few external dependencies as possible
    '';
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    inherit (wayland.meta) platforms;
    mainProgram = "dwl";
  };
})
